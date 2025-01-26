import 'package:challengeone/models/challenge_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChallengeProvider {
  final FirebaseFirestore firebaseFirestore;
  ChallengeProvider({
    required this.firebaseFirestore,
  });

  Stream<List<ChallengeModel>> getChallenges(String uid) {
    try {
      return firebaseFirestore
          .collection('challenge')
          .where('uid', isEqualTo: uid)
          .snapshots()
          .map((querySnapshot) {
        List<ChallengeModel> challenges = [];
        for (var challenge in querySnapshot.docs) {
          final challengeModel = ChallengeModel.fromDocumentSnapshot(challenge);
          challenges.add(challengeModel);
        }
        return challenges;
      });
    } catch (e) {
      throw Exception();
    }
  }

  Stream<List<ChallengeModel>> getAllChallenges() {
    try {
      return firebaseFirestore
          .collection('challenge')
          .snapshots()
          .map((querySnapshot) {
        List<ChallengeModel> challenges = [];
        for (var challenge in querySnapshot.docs) {
          final challengeModel = ChallengeModel.fromDocumentSnapshot(challenge);
          challenges.add(challengeModel);
        }
        return challenges;
      });
    } catch (e) {
      throw Exception();
    }
  }
}
