import 'package:challengeone/config/color.dart';
import 'package:challengeone/pages/story_page.dart';
import 'package:challengeone/widgets/imageavatar_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final auth = FirebaseAuth.instance;
final firestore = FirebaseFirestore.instance;

class Stories extends StatefulWidget {
  const Stories({super.key});

  @override
  State<Stories> createState() => _StoriesState();
}

class _StoriesState extends State<Stories> {
  List<Map<String, String>> userInfo = [];
  bool isLoading = true;
  late User? currentUser;

  @override
  void initState() {
    currentUser = FirebaseAuth.instance.currentUser;
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore.collection('user').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong'));
        }

        userInfo = snapshot.data!.docs.map((doc) {
          return {
            "name": doc['name'] as String,
            "profileImageUrl": doc['profileImageUrl'] as String,
            "uid": doc['uid'] as String,
          };
        }).toList();

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  GestureDetector(
                    onTap: () => _openStoryPage(
                        _findMyIndex(currentUser!.uid)), // 내 uid로 설정
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
                      child: ImageAvatar(
                        imageUrl: userInfo[_findMyIndex(currentUser!.uid)]
                            ['profileImageUrl'],
                        size: 80,
                        type: Shape.MYSTORY,
                      ),
                    ),
                  ),
                  const Text(
                    '내 스토리',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: grey50,
                    ),
                  ),
                ],
              ),
              // 현재 사용자를 제외한 다른 사용자들만 출력
              ...userInfo
                  .where((user) => user['uid'] != currentUser!.uid)
                  .map((user) {
                int index = userInfo.indexOf(user);
                return GestureDetector(
                  onTap: () => _openStoryPage(index), // uid 사용
                  child: SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
                          child: ImageAvatar(
                            size: 80,
                            imageUrl: user['profileImageUrl'],
                            type: Shape.STORY,
                          ),
                        ),
                        Text(
                          user['name'] ?? 'user$index',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            color: grey80,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
