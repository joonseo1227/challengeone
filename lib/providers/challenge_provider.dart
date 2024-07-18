import 'package:challengeone/models/challenge.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDB {
  final FirebaseFirestore firebaseFirestore;
  FirebaseDB({
    required this.firebaseFirestore,
  });

  Stream<List<Challenge>> getChallenges() {
    try {
      return firebaseFirestore
          .collection('challenge')
          .snapshots()
          .map((querySnapshot) {
        List<Challenge> challenges = [];
        for (var challenge in querySnapshot.docs) {
          final challengeModel = Challenge.fromDocumentSnapshot(challenge);
          challenges.add(challengeModel);
        }
        return challenges;
      });
    } catch (e) {
      throw Exception();
    }
  }
}
