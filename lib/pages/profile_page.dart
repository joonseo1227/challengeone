import 'package:challengeone/config/color.dart';
import 'package:challengeone/pages/add_challenge_page.dart';
import 'package:challengeone/pages/people_page.dart';
import 'package:challengeone/pages/settings_page.dart';
import 'package:challengeone/pages/story_page.dart';
import 'package:challengeone/providers/story_provider.dart';
import 'package:challengeone/widgets/button_widget.dart';
import 'package:challengeone/widgets/challenges_widget.dart';
import 'package:challengeone/widgets/imageavatar_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileTab extends StatefulWidget {
  final String uid;

  const ProfileTab({required this.uid});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  late User? currentUser;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool isFollowing = false;
  bool isLoading = true;
  DocumentSnapshot? userProfile;
  int followersCount = 0;
  int followingCount = 0;
  List<Map<String, String>> userInfo = [];

  @override
  void initState() {
    currentUser = FirebaseAuth.instance.currentUser;

    super.initState();
    _loadProfile();
    _checkIfFollowing();
    _fetchCounts();
    _loadData();
  }

  // Firestore에서 사용자 정보를 비동기로 가져오는 함수
  Future<void> _loadData() async {
    StoryProvider storyProvider =
        StoryProvider(firebaseFirestore: FirebaseFirestore.instance);

    List<Map<String, String>> fetchedUserInfo =
        await storyProvider.getUserInfo();

    setState(() {
      userInfo = fetchedUserInfo;
      isLoading = false;
    });
  }

  // 현재 로그인한 유저의 UID 인덱스를 찾는 함수
  int _findMyIndex(String uid) {
    return userInfo.indexWhere((user) => user['uid'] == uid);
  }

  // 스토리 페이지를 열 때 uid를 사용
  void _openStoryPage(int select) {
    final uidList = userInfo.map((user) => user['uid'] ?? 'guest').toList();

    context.pushTransparentRoute(
      StoryPage(uidList: uidList, initIndex: select),
      transitionDuration: const Duration(milliseconds: 100),
      reverseTransitionDuration: const Duration(milliseconds: 100),
    );
  }

  Future<void> _fetchCounts() async {
    if (currentUser != null) {
      var followersSnapshot = await FirebaseFirestore.instance
          .collection('following')
          .doc(currentUser!.uid)
          .collection('userFollowers')
          .get();
      var followingSnapshot = await FirebaseFirestore.instance
          .collection('following')
          .doc(currentUser!.uid)
          .collection('userfollowing')
          .get();

      setState(() {
        followersCount = followersSnapshot.size;
        followingCount = followingSnapshot.size;
        isLoading = false;
      });
    }
  }

  Future<void> _loadProfile() async {
    var userDoc = await firestore.collection('user').doc(widget.uid).get();
    setState(() {
      userProfile = userDoc;
      isLoading = false;
    });
  }

  Future<void> _checkIfFollowing() async {
    var followDoc = await firestore
        .collection('following')
        .doc(auth.currentUser?.uid)
        .collection('userfollowing')
        .doc(widget.uid)
        .get();
    setState(() {
      isFollowing = followDoc.exists;
    });
  }

  Future<void> _followUser() async {
    try {
      await firestore
          .collection('following')
          .doc(auth.currentUser?.uid)
          .collection('userfollowing')
          .doc(widget.uid)
          .set({
        'uid': widget.uid,
      });
      await firestore
          .collection('following')
          .doc(widget.uid)
          .collection('userFollowers')
          .doc(auth.currentUser?.uid)
          .set({
        'uid': auth.currentUser?.uid,
      });
      setState(() {
        isFollowing = true;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _unfollowUser() async {
    try {
      await firestore
          .collection('following')
          .doc(auth.currentUser?.uid)
          .collection('userfollowing')
          .doc(widget.uid)
          .delete();
      await firestore
          .collection('following')
          .doc(widget.uid)
          .collection('userFollowers')
          .doc(auth.currentUser?.uid)
          .delete();
      setState(() {
        isFollowing = false;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('프로필'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(userProfile?['name'] ?? '프로필'),
        actions: [
          if (widget.uid == auth.currentUser?.uid)
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SettingsPage()));
              },
              icon: const Icon(Icons.settings),
              color: grey100,
            ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 0, 16),
            child: Row(
              children: [
                if (widget.uid == auth.currentUser?.uid)
                  GestureDetector(
                    onTap: () => _openStoryPage(_findMyIndex(currentUser!.uid)),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
                      child: ImageAvatar(
                        imageUrl: userProfile?['profileImage'] ?? 'url',
                        size: 96,
                        type: Shape.MYSTORY,
                      ),
                    ),
                  )
                else
                  GestureDetector(
                    onTap: () =>
                        _openStoryPage(_findMyIndex(userProfile?['uid'])),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
                      child: ImageAvatar(
                        imageUrl: userProfile?['profileImage'] ?? 'url',
                        size: 96,
                        type: Shape.STORY,
                      ),
                    ),
                  ),
                const Spacer(),
                const Column(
                  children: [
                    Text(
                      '15',
                      style: TextStyle(
                        color: grey100,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '레벨',
                      style: TextStyle(
                        color: grey50,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                // 팔로워와 팔로잉 텍스트 클릭 시 전달하는 uid를 widget.uid로 수정합니다.
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            PeopleTab(initialIndex: 0, uid: widget.uid)));
                  },
                  child: Column(
                    children: [
                      Text(
                        '$followersCount',
                        style: const TextStyle(
                          color: grey100,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Text(
                        '팔로워',
                        style: TextStyle(
                          color: grey50,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            PeopleTab(initialIndex: 1, uid: widget.uid)));
                  },
                  child: Column(
                    children: [
                      Text(
                        '$followingCount',
                        style: const TextStyle(
                          color: grey100,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Text(
                        '팔로잉',
                        style: TextStyle(
                          color: grey50,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),
              ],
            ),
          ),
          if (widget.uid != auth.currentUser?.uid)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  if (isFollowing)
                    SecondaryButton(
                      text: '팔로잉',
                      onTap: _unfollowUser,
                    )
                  else
                    PrimaryButton(
                      text: '팔로우',
                      onTap: _followUser,
                    ),
                ],
              ),
            ),
          const SizedBox(
            height: 16,
          ),
          UserChallenges(uid: widget.uid),
          const SizedBox(
            height: 16,
          ),
        ],
      ),
      floatingActionButton: Visibility(
        visible: widget.uid == auth.currentUser?.uid,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AddChallengePage()));
          },
          backgroundColor: blue50,
          shape: const CircleBorder(),
          elevation: 0,
          child: const Icon(
            Icons.add,
            color: white,
          ),
        ),
      ),
    );
  }
}
