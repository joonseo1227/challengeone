import 'package:challengeone/config/color.dart';
import 'package:challengeone/models/theme_model.dart';
import 'package:challengeone/pages/add_challenge_page.dart';
import 'package:challengeone/pages/main/people_page.dart';
import 'package:challengeone/pages/settings_page.dart';
import 'package:challengeone/pages/story_page.dart';
import 'package:challengeone/providers/story_provider.dart';
import 'package:challengeone/providers/theme_provider.dart';
import 'package:challengeone/widgets/c_button.dart';
import 'package:challengeone/widgets/c_ink_well.dart';
import 'package:challengeone/widgets/challenges_widget.dart';
import 'package:challengeone/widgets/imageavatar_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileTab extends ConsumerStatefulWidget {
  final String uid;

  const ProfileTab({super.key, required this.uid});

  @override
  ConsumerState<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends ConsumerState<ProfileTab> {
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
    _setupFollowersListener();
    _setupFollowingListener();
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
    final uidList = userInfo.map((user) => user['uid'] ?? '').toList();

    context.pushTransparentRoute(
      StoryPage(uidList: uidList, initIndex: select),
      transitionDuration: const Duration(milliseconds: 100),
      reverseTransitionDuration: const Duration(milliseconds: 100),
    );
  }

  void _setupFollowersListener() {
    firestore
        .collection('following')
        .doc(widget.uid)
        .collection('userFollowers')
        .snapshots()
        .listen((snapshot) {
      setState(() {
        followersCount = snapshot.size;
      });
    });
  }

  void _setupFollowingListener() {
    firestore
        .collection('following')
        .doc(widget.uid)
        .collection('userFollowing')
        .snapshots()
        .listen((snapshot) {
      setState(() {
        followingCount = snapshot.size;
      });
    });
  }

  Future<void> _loadProfile() async {
    var userDoc = await firestore
        .collection('user')
        .doc(widget.uid)
        .get(); // 현재 프로필의 사용자 UID로 접근
    setState(() {
      userProfile = userDoc;
      isLoading = false;
    });
  }

  Future<void> _checkIfFollowing() async {
    var currentUid = auth.currentUser!.uid;
    var doc = await firestore
        .collection('following')
        .doc(currentUid)
        .collection('userFollowing')
        .doc(widget.uid)
        .get(); // 현재 프로필의 사용자 UID로 접근
    setState(() {
      isFollowing = doc.exists;
    });
  }

  Future<void> _followUser() async {
    var currentUid = auth.currentUser!.uid;

    setState(() {
      isLoading = true;
    });

    await firestore
        .collection('following')
        .doc(currentUid)
        .collection('userFollowing')
        .doc(widget.uid)
        .set({}); // 현재 프로필의 사용자 UID로 팔로우 추가

    await firestore
        .collection('following')
        .doc(widget.uid)
        .collection('userFollowers')
        .doc(currentUid)
        .set({}); // 현재 프로필의 사용자 UID로 팔로워 추가

    setState(() {
      isFollowing = true;
      isLoading = false;
    });
  }

  Future<void> _unfollowUser() async {
    var currentUid = auth.currentUser!.uid;

    setState(() {
      isLoading = true;
    });

    await firestore
        .collection('following')
        .doc(currentUid)
        .collection('userFollowing')
        .doc(widget.uid)
        .delete(); // 현재 프로필의 사용자 UID로 팔로잉 제거

    await firestore
        .collection('following')
        .doc(widget.uid)
        .collection('userFollowers')
        .doc(currentUid)
        .delete(); // 현재 프로필의 사용자 UID로 팔로워 제거

    setState(() {
      isFollowing = false;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);

    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('프로필 로드 중...'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(userProfile != null ? userProfile!['name'] : '프로필'),
        actions: [
          if (widget.uid == auth.currentUser?.uid)
            CInkWell(
              onTap: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => const SettingsPage(),
                  ),
                );
              },
              child: SizedBox(
                width: 32,
                height: 32,
                child: Icon(
                  Icons.settings,
                  size: 28,
                  color: ThemeModel.sub3(isDarkMode),
                ),
              ),
            ),
          const SizedBox(
            width: 16,
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
                        imageUrl: userProfile?['profileImageUrl'] ?? '',
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
                        imageUrl: userProfile?['profileImageUrl'] ?? '',
                        size: 96,
                        type: Shape.STORY,
                      ),
                    ),
                  ),
                const Spacer(),
                Column(
                  children: [
                    Text(
                      '15',
                      style: TextStyle(
                        color: ThemeModel.text(isDarkMode),
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '레벨',
                      style: TextStyle(
                        color: ThemeModel.sub4(isDarkMode),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) =>
                            PeopleTab(initialIndex: 0, uid: widget.uid),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Text(
                        '$followersCount',
                        style: TextStyle(
                          color: ThemeModel.text(isDarkMode),
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '팔로워',
                        style: TextStyle(
                          color: ThemeModel.sub4(isDarkMode),
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
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => PeopleTab(
                          initialIndex: 1,
                          uid: widget.uid,
                        ),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Text(
                        '$followingCount',
                        style: TextStyle(
                          color: ThemeModel.text(isDarkMode),
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '팔로잉',
                        style: TextStyle(
                          color: ThemeModel.sub4(isDarkMode),
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
                    CButton(
                      style: CButtonStyle.tertiary(isDarkMode),
                      label: '팔로잉',
                      icon: Icons.check,
                      width: double.maxFinite,
                      onTap: _unfollowUser,
                    )
                  else
                    CButton(
                      label: '팔로우',
                      icon: Icons.add,
                      width: double.maxFinite,
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
            height: 32,
          ),
        ],
      ),
      floatingActionButton: Visibility(
        visible: widget.uid == auth.currentUser?.uid,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => AddChallengePage(),
              ),
            );
          },
          backgroundColor: blue60,
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
