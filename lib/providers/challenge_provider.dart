import 'package:challengeone/models/challenge.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChallengeProvider {
  final FirebaseFirestore firebaseFirestore;
  ChallengeProvider({
    required this.firebaseFirestore,
  });

  Stream<List<Challenge>> getChallenges(String uid) {
    try {
      return firebaseFirestore
          .collection('challenge')
          .where('uid', isEqualTo: uid)
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

  Stream<List<Challenge>> getAllChallenges() {
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
