import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:wave/models/comment_post_model.dart';
import 'package:wave/models/like_post_model.dart';
import 'package:wave/models/post_content_model.dart';
import 'package:wave/models/post_model.dart';
import 'package:wave/models/response_model.dart';
import 'package:wave/models/user_model.dart';
import 'package:wave/services/comment_notification_service.dart';
import 'package:wave/utils/constants/database_endpoints.dart';

class PostData {
  static Future<Post> createPostModel(
      {String? caption,
      List<User>? mentionedUsers,
      List<File>? mediaFiles,
      required String id,
      required String userId}) async {
    Post post = Post(
        id: id,
        postList: [],
        createdAt: DateTime.now(),
        userId: userId,
        caption: caption ?? "",
        mentions: []);

    List<PostContent> postList = [];
    // Fill caption if present
    if (caption != null) {
      post = post.copyWith(caption: caption);
      "Filled caption".printInfo();
    }
    // Fill mentioned User list if present
    if (mentionedUsers != null && mentionedUsers.isNotEmpty) {
      "Filling mentions".printInfo();
      List<dynamic> mentionedUserID = [];
      for (var index = 0; index < mentionedUsers.length; index++) {
        mentionedUserID.add(mentionedUsers[index].id);
      }
      post = post.copyWith(mentions: mentionedUserID);
    }
    "Let's see what has changed : ".printInfo();
    post.toString().printInfo();
    // Add images to the server if possible
    // Add images to the server if possible
    if (mediaFiles != null && mediaFiles.isNotEmpty) {
      // Start concurrent process to save media files to the server
      await for (var response in getMediaDetails(mediaFiles, post.id)) {
        if (response.responseStatus) {
          Map<String, String> mediaDetail = response.response;
          PostContent pc =
              PostContent(type: mediaDetail['type']!, url: mediaDetail['url']!);
          postList.add(pc);
        }
      }
    }
    post = post.copyWith(createdAt: DateTime.now());
    post = post.copyWith(postList: postList);

    return post;
    // return Post(id: id, postList: postList, createdAt: createdAt, userId: userId, mentions: mentions)
  }

  static Stream<CustomResponse> getMediaDetails(
      List<File> files, String postId) async* {
    final FirebaseStorage storage = FirebaseStorage.instance;

    List<Future<Map<String, String>>> uploadTasks = files.map((file) async {
      try {
        String fileName = file.path.split('/').last;
        String fileExtension = fileName.split('.').last.toLowerCase();
        String fileType = getFileType(fileExtension);

        Reference ref =
            storage.ref().child('posts/$postId/$fileType/$fileName');
        UploadTask uploadTask = ref.putFile(file);

        // Await the completion of the upload task and get the download URL
        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();

        // Return a map containing the download URL and file type
        return {
          'url': downloadUrl,
          'type': fileType,
        };
      } on FirebaseException catch (e) {
        // Handle Firebase exceptions
        throw Exception('Failed to upload file: ${e.message}');
      }
    }).toList();

    // Wait for all upload tasks to complete
    List<Map<String, String>> downloadDetails = await Future.wait(uploadTasks);

    // Yield the responses
    for (Map<String, String> details in downloadDetails) {
      yield CustomResponse(responseStatus: true, response: details);
    }
  }

  static String getFileType(String fileExtension) {
    // Define the logic to determine the file type based on the extension
    switch (fileExtension) {
      case 'jpg':
      case 'jpeg':
      case 'png':
        return 'image';
      case 'mp4':
      case 'mov':
        return 'video';
      default:
        return 'unknown';
    }
  }

  static Future<bool> alreadySentNotificationForThis(
      {required String postId, required String posterId}) async {
    String myUserId = fb.FirebaseAuth.instance.currentUser!.uid;
    var res = await Database.getNotificationDatabase(posterId)
        .where('type', isEqualTo: 'like')
        .where('postId', isEqualTo: postId)
        .where('userWhoLiked', isEqualTo: myUserId)
        .get();
    if (res.docs.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  static Future<CustomResponse> likePostWithId(
      {required String postId, required String userId}) async {
    Like like = Like(id: userId, userId: userId, createdAt: DateTime.now());
    try {
      var res = await Database.getPostLikesDatabase(postId)
          .doc(userId)
          .set(like.toMap());
      
      return CustomResponse(responseStatus: true);
    } on FirebaseException catch (error) {
      return CustomResponse(responseStatus: false, response: error.toString());
    }
  }

  static Future<CustomResponse> unLikePostWithId(
      {required String postId, required String userId}) async {
    Like like = Like(id: userId, userId: userId, createdAt: DateTime.now());
    try {
      Database.getPostLikesDatabase(postId).doc(userId).delete();
      return CustomResponse(responseStatus: true);
    } on FirebaseException catch (error) {
      return CustomResponse(responseStatus: false, response: error.toString());
    }
  }

  static Future<Post> getPost(String postId) async {
    var res = await Database.postDatabase.doc(postId).get();
    Post post = Post.fromMap(res.data()!);
    return post;
  }

  static Future<CustomResponse> commentOnPostWithId(
      {required postId,
      required String userId,
      required String commentString}) async {
    Comment comment = Comment(
        id: "id",
        userId: userId,
        postId: postId,
        comment: commentString,
        createdAt: DateTime.now());
    try {
      var res =
          await Database.getPostCommentsDatabase(postId).add(comment.toMap());

      await Database.getPostCommentsDatabase(postId)
          .doc(res.id)
          .update({'id': res.id});

      CommentNotificationService.sendNotification(
          comment: commentString,
          myUserId: fb.FirebaseAuth.instance.currentUser!.uid,
          postId: postId);

      return CustomResponse(responseStatus: true, response: res.id);
    } on FirebaseException catch (e) {
      return CustomResponse(responseStatus: false, response: e.toString());
    }
  }

  static Future<CustomResponse> likeOnComment({
    required String postId,
    required String commentId,
    required String userId,
  }) async {
    try {
      Like like = Like(createdAt: DateTime.now(), id: userId, userId: userId);
      await Database.getPostCommentsLikesDatabase(postId, commentId)
          .doc(userId)
          .set(like.toMap());
      return CustomResponse(responseStatus: true);
    } on FirebaseException catch (e) {
      return CustomResponse(responseStatus: false, response: e.toString());
    }
  }

  static Future<CustomResponse> unlikeOnComment({
    required String postId,
    required String commentId,
    required String userId,
  }) async {
    try {
      await Database.getPostCommentsLikesDatabase(postId, commentId)
          .doc(userId)
          .delete();
      return CustomResponse(responseStatus: true);
    } on FirebaseException catch (e) {
      return CustomResponse(responseStatus: false, response: e.toString());
    }
  }
}
