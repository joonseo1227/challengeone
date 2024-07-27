import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final auth = FirebaseAuth.instance;

class PeopleProvider {
  final FirebaseFirestore firebaseFirestore;
  PeopleProvider({
    required this.firebaseFirestore,
  });
  User? currentUser = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> followUser(String uid) async {
    try {
      await firestore
          .collection('following')
          .doc(auth.currentUser?.uid)
          .collection('userfollowing')
          .doc(uid)
          .set({
        'uid': uid,
      });
      await firestore
          .collection('following')
          .doc(uid)
          .collection('userFollowers')
          .doc(auth.currentUser?.uid)
          .set({
        'uid': auth.currentUser?.uid,
      });
    } catch (e) {
      throw Exception();
    }
  }

  Future<void> unfollowUser(String uid) async {
    try {
      await firestore
          .collection('following')
          .doc(auth.currentUser?.uid)
          .collection('userfollowing')
          .doc(uid)
          .delete();
      await firestore
          .collection('following')
          .doc(uid)
          .collection('userFollowers')
          .doc(auth.currentUser?.uid)
          .delete();
    } catch (e) {
      throw Exception();
    }
  }
}
