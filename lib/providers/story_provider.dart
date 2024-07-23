import 'package:challengeone/models/story.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StoryProvider {
  final FirebaseFirestore firebaseFirestore;
  StoryProvider({
    required this.firebaseFirestore,
  });

  Stream<List<Story>> getMyStory(String uid) {
    try {
      return firebaseFirestore
          .collection('story')
          .where('uid', isEqualTo: uid)
          .snapshots()
          .map((querySnapshot) {
        List<Story> stories = [];
        for (var story in querySnapshot.docs) {
          final storyModel = Story.fromDocumentSnapshot(story);
          stories.add(storyModel);
        }
        return stories;
      });
    } catch (e) {
      throw Exception();
    }
  }

  Stream<List<Story>> getAllStory() {
    try {
      return firebaseFirestore
          .collection('story')
          .snapshots()
          .map((querySnapshot) {
        List<Story> stories = [];
        for (var story in querySnapshot.docs) {
          final storyModel = Story.fromDocumentSnapshot(story);
          stories.add(storyModel);
        }
        return stories;
      });
    } catch (e) {
      throw Exception();
    }
  }
}
