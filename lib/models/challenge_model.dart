import 'package:cloud_firestore/cloud_firestore.dart';

class ChallengeModel {
  final String challengeDescription;
  final String challengeGoal;
  final String challengeName;
  final String uid;

  ChallengeModel({
    required this.challengeDescription,
    required this.challengeGoal,
    required this.challengeName,
    required this.uid,
  });

  factory ChallengeModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    return ChallengeModel(
      challengeDescription: doc['challengeDescription'],
      challengeGoal: doc['challengeGoal'],
      challengeName: doc['challengeName'],
      uid: doc['uid'],
    );
  }
}
