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
      await firestore.collection('user').doc(auth.currentUser?.uid).update({
        //'followingCount': 1 증가,
      });
      await firestore.collection('user').doc(uid).update({
        //'followerCount': 1 증가,
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
      await firestore.collection('user').doc(auth.currentUser?.uid).update({
        //'followingCount': -1 증가,
      });
      await firestore.collection('user').doc(uid).update({
        //'followerCount': -1 증가,
      });
    } catch (e) {
      throw Exception();
    }
  }
}
