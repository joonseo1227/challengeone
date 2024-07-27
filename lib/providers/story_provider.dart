import 'package:challengeone/config/color.dart';
import 'package:challengeone/models/story.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';

class StoryProvider {
  final FirebaseFirestore firebaseFirestore;
  StoryProvider({
    required this.firebaseFirestore,
  });

  // 특정 사용자의 정보를 가져오는 메서드
  Future<Map<String, String>> getUserInfoByUid(String uid) async {
    try {
      DocumentSnapshot doc =
          await firebaseFirestore.collection('user').doc(uid).get();
      return {
        "name": doc['name'] as String,
        "profileImage": doc['profileImage'] as String,
        "uid": doc['uid'] as String,
      };
    } catch (e) {
      throw Exception();
    }
  }

  // 특정 사용자의 스토리를 가져오는 메서드
  Future<List<StoryItem>> getUserStoriesByUid(String uid) async {
    try {
      QuerySnapshot querySnapshot = await firebaseFirestore
          .collection('story')
          .where('uid', isEqualTo: uid)
          .get();

      return querySnapshot.docs.map((doc) {
        Story story = Story.fromDocumentSnapshot(doc);
        return StoryItem.pageImage(
          url: story.storyImageUrl,
          caption: Text(
            story.storyCaption,
            style: const TextStyle(
              fontSize: 24,
              color: white,
            ),
          ),
          controller: StoryController(),
        );
      }).toList();
    } catch (e) {
      throw Exception();
    }
  }

  // 전체 사용자 정보를 가져오는 메서드
  Future<List<Map<String, String>>> getUserInfo() async {
    try {
      QuerySnapshot querySnapshot =
          await firebaseFirestore.collection('user').get();
      return querySnapshot.docs.map((doc) {
        return {
          "name": doc['name'] as String,
          "profileImage": doc['profileImage'] as String,
          "uid": doc['uid'] as String,
        };
      }).toList();
    } catch (e) {
      throw Exception();
    }
  }

  // 전체 사용자의 스토리를 가져오는 메서드
  Future<List<List<StoryItem>>> getUserStories() async {
    try {
      List<List<StoryItem>> userStories = [];
      QuerySnapshot querySnapshot =
          await firebaseFirestore.collection('story').get();
      Map<String, List<Story>> userStoryMap = {};

      for (var doc in querySnapshot.docs) {
        Story story = Story.fromDocumentSnapshot(doc);
        if (userStoryMap.containsKey(story.uid)) {
          userStoryMap[story.uid]!.add(story);
        } else {
          userStoryMap[story.uid] = [story];
        }
      }

      userStoryMap.forEach((uid, stories) {
        List<StoryItem> storyItems = stories.map((story) {
          return StoryItem.pageImage(
            url: story.storyImageUrl,
            caption: Text(
              story.storyCaption,
              style: const TextStyle(
                fontSize: 24,
                color: white,
              ),
            ),
            controller: StoryController(),
          );
        }).toList();

        userStories.add(storyItems);
      });

      return userStories;
    } catch (e) {
      throw Exception();
    }
  }
}
