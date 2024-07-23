import 'package:cloud_firestore/cloud_firestore.dart';

class Story {
  final String uid;
  final String storyImageUrl;
  final String storyCaption;

  Story({
    required this.uid,
    required this.storyImageUrl,
    required this.storyCaption,
  });

  factory Story.fromDocumentSnapshot(DocumentSnapshot doc) {
    return Story(
      uid: doc['uid'],
      storyImageUrl: doc['storyImageUrl'],
      storyCaption: doc['storyCaption'],
    );
  }
}
