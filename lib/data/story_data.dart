import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:wave/models/response_model.dart';
import 'package:wave/models/story_content_model.dart';
import 'package:wave/models/story_model.dart';
import 'package:wave/utils/constants/database_endpoints.dart';
import 'package:wave/utils/enums.dart';

class StoryData {
  static Future<CustomResponse> createStory(
      File mediaFile, STORY_TYPE story_type, String userId) async {
    try {
      // Check if already there is some story
      var storyDocRes = await Database.getStories(userId).limit(1).get();
      storyDocRes.docs.length.printInfo();
      final FirebaseStorage storage = FirebaseStorage.instance;
      if (storyDocRes.docs.isNotEmpty) {
        Story story = Story.fromMap(
            storyDocRes.docs.first.data() as Map<String, dynamic>);

        story.toString().printInfo();

        List<StoryContent> storyContents = story.contents;
        int numberOfStories = storyContents.length;

        Reference ref = storage.ref().child('storis/$userId/$numberOfStories');
        UploadTask uploadTask = ref.putFile(mediaFile);

        // Await the completion of the upload task and get the download URL
        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();
        // Create a new story
        StoryContent storyContent = StoryContent(
            url: downloadUrl,
            id: numberOfStories.toString(),
            createdAt: DateTime.now(),
            story_type: story_type,
            seenBy: []);

        storyContents.add(storyContent);
        story = story.copyWith(contents: storyContents);
        await Database.getStories(userId).doc(story.id).update(story.toMap());
        return CustomResponse(responseStatus: true, response: story);
      } else {
        Reference ref = storage.ref().child('storis/$userId/0');
        UploadTask uploadTask = ref.putFile(mediaFile);

        // Await the completion of the upload task and get the download URL
        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();
        // Create a new story
        StoryContent storyContent = StoryContent(
            url: downloadUrl,
            id: '0',
            createdAt: DateTime.now(),
            story_type: story_type,
            seenBy: []);
        List<StoryContent> stories = [storyContent];
        Story story = Story(userId: userId, id: 'id', contents: stories);
        var uploadStoryRes =
            await Database.getStories(userId).add(story.toMap());
        await Database.getStories(userId)
            .doc(uploadStoryRes.id)
            .update({'id': uploadStoryRes.id});
        story = story.copyWith(id: uploadStoryRes.id);
        return CustomResponse(responseStatus: true, response: story);
      }
    } on FirebaseException catch (e) {
      return CustomResponse(responseStatus: false, response: e.message);
    }
  }

  static Future<void> deleteExpiredStoryContents(String userId) async {
    try {
      // Fetch the user's stories
      var storyDocs = await Database.getStories(userId).get();

      // Get the current time
      DateTime now = DateTime.now();

      if (storyDocs.docs.isEmpty) {
        return;
      } else {
        var storyDoc = storyDocs.docs.first;
        Story story = Story.fromMap(storyDoc.data() as Map<String, dynamic>);
        List<StoryContent> validContents = story.contents.where((content) {
          return now.difference(content.createdAt).inHours < 12;
        }).toList();

        // If there are no valid contents left, delete the entire story document
        if (validContents.isEmpty) {
          await Database.getStories(userId).doc(story.id).delete();
        } else {
          // Otherwise, update the story document with the valid contents
          story = story.copyWith(contents: validContents);
          await Database.getStories(userId).doc(story.id).update(story.toMap());
        }
      }
    } on FirebaseException catch (e) {
      print("Error deleting expired story contents: ${e.message}");
    }
  }

  static Future<CustomResponse> fetchMyStory({String? userId}) async {
    try {
      var storyDocRes = await Database.getStories(
              userId ?? FirebaseAuth.instance.currentUser!.uid)
          .limit(1)
          .get();
      if (storyDocRes.docs.isEmpty) {
        return CustomResponse(responseStatus: false);
      } else {
        Story story = Story.fromMap(
            storyDocRes.docs.first.data() as Map<String, dynamic>);

        // Filter the story contents to only include those created within the last 12 hours
        DateTime now = DateTime.now();
        List<StoryContent> validContents = story.contents
            .where((content) => now.difference(content.createdAt).inHours < 12)
            .toList();

        // If there are no valid contents, return an empty response
        if (validContents.isEmpty) {
          return CustomResponse(responseStatus: false);
        }

        // Return the filtered story
        story = story.copyWith(contents: validContents);
        return CustomResponse(responseStatus: true, response: story);
      }
    } on FirebaseException catch (e) {
      return CustomResponse(responseStatus: false, response: e.message);
    }
  }

  static Future<void> increaseViewCountOnStory(
      {required String userId,
      required String storyId,
      required String subStoryId}) async {
    try {
      if (userId == FirebaseAuth.instance.currentUser!.uid) {
        return;
      }

      DocumentReference storyDocRef = Database.getStories(userId).doc(storyId);
      DocumentSnapshot storySnapshot = await storyDocRef.get();

      if (storySnapshot.exists) {
        Story story =
            Story.fromMap(storySnapshot.data() as Map<String, dynamic>);

        // Find the specific subStory content
        StoryContent subStory = story.contents.firstWhere(
            (content) => content.id == subStoryId,
            orElse: () => throw Exception('SubStory not found'));

        String currentUserId = FirebaseAuth.instance.currentUser!.uid;

        if (!subStory.seenBy.contains(currentUserId)) {
          subStory.seenBy.add(currentUserId);

          // Update the story content with the new seenBy list
          int index =
              story.contents.indexWhere((content) => content.id == subStoryId);
          story.contents[index] = subStory;

          // Update Firestore with the new data
          await storyDocRef.update(story.toMap());
          "View count increased successfully.".printInfo();
        } else {
          "User has already viewed this story.".printInfo();
        }
      } else {
        "Story does not exist.".printError();
      }
    } on FirebaseException catch (e) {
      "Error increasing view count: ${e.message}".printError();
    }
  }
}
