import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wave/models/post_model.dart';
import 'package:wave/utils/constants/database_endpoints.dart';
import 'package:wave/utils/enums.dart';

class FeedPostController extends ChangeNotifier {
  List<Post> posts = [];
  POSTS_STATE postState = POSTS_STATE.ABSENT;
  int currentPostLimit = 15;
  DocumentSnapshot? lastDocument;


  Future<void> getPosts(List<dynamic> following) async {
    if (following.isEmpty) {
      postState = POSTS_STATE.PRESENT;
      await Future.delayed(Duration.zero);
      notifyListeners();
      return;
    }

    postState = POSTS_STATE.LOADING;
    await Future.delayed(Duration.zero);
    notifyListeners();

    try {
      Query query = Database.postDatabase
          .where('userId', whereIn: following)
          .orderBy('createdAt', descending: true)
          .limit(currentPostLimit);

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument!);
      }

      final postQuerySnapshot = await query.get();
      debugPrint("lenght of posts = ${postQuerySnapshot.docs.length}");
      if (postQuerySnapshot.docs.isNotEmpty) {
        debugPrint("Posts are there");
        lastDocument = postQuerySnapshot.docs.last;
        debugPrint(lastDocument!.data()!.toString());

        for (var index = 0; index < postQuerySnapshot.docs.length; ++index) {
          try {
            Post post = Post.fromMap(postQuerySnapshot.docs[index].data() as Map<String, dynamic>);
            posts.add(post);
            debugPrint("Post added: ${post.caption}");
          } catch (e) {
            debugPrint("Error converting document to Post: $e");
          }
        }

       
      }
      postState = POSTS_STATE.PRESENT;
    } catch (e) {
      postState = POSTS_STATE.PRESENT;
    }

    notifyListeners();
  }



}
