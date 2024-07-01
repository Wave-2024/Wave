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

  static Future<CustomResponse> fetchMyStory() async {
    try {
      var storyDocRes =
          await Database.getStories(FirebaseAuth.instance.currentUser!.uid)
              .limit(1)
              .get();
      if (storyDocRes.docs.isEmpty) {
        return CustomResponse(responseStatus: false);
      } else {
        Story story = Story.fromMap(
            storyDocRes.docs.first.data() as Map<String, dynamic>);
        return CustomResponse(responseStatus: true, response: story);
      }
    } on FirebaseException catch (e) {
      return CustomResponse(responseStatus: false, response: e.message);
    }
  }
}
