import 'package:cloud_firestore/cloud_firestore.dart';

class Challenge {
  final String challengeDescription;
  final String challengeGoal;
  final String challengeName;
  final String uid;

  Challenge({
    required this.challengeDescription,
    required this.challengeGoal,
    required this.challengeName,
    required this.uid,
  });

  factory Challenge.fromDocumentSnapshot(DocumentSnapshot doc) {
    return Challenge(
      challengeDescription: doc['challengeDescription'],
      challengeGoal: doc['challengeGoal'],
      challengeName: doc['challengeName'],
      uid: doc['uid'],
    );
  }
}
