import 'package:challengeone/config/color.dart';
import 'package:challengeone/pages/add_challenge_page.dart';
import 'package:challengeone/pages/people_page.dart';
import 'package:challengeone/pages/settings_page.dart';
import 'package:challengeone/pages/story_page.dart';
import 'package:challengeone/widgets/challenges_widget.dart';
import 'package:challengeone/widgets/imageavatar_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:challengeone/providers/story_provider.dart';


class ProfileTab extends StatefulWidget {
  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  late User? currentUser;
  bool isLoading = true;
  List<Map<String, String>> userInfo = [];

  // Firestore에서 사용자 정보를 비동기로 가져오는 함수
  Future<void> _loadData() async {
    StoryProvider storyProvider =
    StoryProvider(firebaseFirestore: FirebaseFirestore.instance);

    List<Map<String, String>> fetchedUserInfo =
    await storyProvider.getUserInfo();

    setState(() {
      userInfo = fetchedUserInfo;
      isLoading = false;

      if (currentUser != null) {
        int myIndex = _findMyIndex(currentUser!.uid);
        print('My UID index: $myIndex');
      }
    });
  }

  // 현재 로그인한 유저의 UID 인덱스를 찾는 함수
  int _findMyIndex(String uid) {
    return userInfo.indexWhere((user) => user['uid'] == uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          user?.displayName ?? '게스트',
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SettingsPage()));
            },
            icon: Icon(Icons.settings),
            color: grey100,
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(16, 16, 0, 16),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const StoryPage(initIndex: -1),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
                    child: ImageAvatar(
                      imageUrl: ,
                      size: 96,
                      type: Shape.MYSTORY,
                    ),
                  ),
                ),
                Spacer(),
                Column(
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
                Spacer(),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PeopleTab(initialIndex: 0)));
                  },
                  child: Column(
                    children: [
                      Text(
                        '5',
                        style: TextStyle(
                          color: grey100,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
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
                Spacer(),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PeopleTab(initialIndex: 1)));
                  },
                  child: Column(
                    children: [
                      Text(
                        '5',
                        style: TextStyle(
                          color: grey100,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
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
                Spacer(),
              ],
            ),
          ),
          const SizedBox(
            height: 32,
          ),
          MyChallenges(),
          SizedBox(
            height: 16,
          ),
          Text(
            '이름: ${userProfile?['name']}',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 16),
          if (widget.uid != auth.currentUser?.uid)
            ElevatedButton(
              onPressed: isFollowing ? _unfollowUser : _followUser,
              child: Text(isFollowing ? '언팔로우' : '팔로우'),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AddChallengePage()));
        },
        backgroundColor: blue50,
        shape: CircleBorder(),
        elevation: 0,
        child: Icon(
          Icons.add,
          color: white,
        ),
      ),
    );
  }
}