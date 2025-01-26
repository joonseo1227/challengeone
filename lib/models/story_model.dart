import 'package:cloud_firestore/cloud_firestore.dart';

class StoryModel {
  final String uid;
  final String storyImageUrl;
  final String storyCaption;

  StoryModel({
    required this.uid,
    required this.storyImageUrl,
    required this.storyCaption,
  });

  factory StoryModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    return StoryModel(
      uid: doc['uid'],
      storyImageUrl: doc['storyImageUrl'],
      storyCaption: doc['storyCaption'],
    );
  }
}
