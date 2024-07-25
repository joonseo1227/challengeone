import 'package:challengeone/config/color.dart';
import 'package:challengeone/pages/story_page.dart';
import 'package:challengeone/providers/story_provider.dart';
import 'package:challengeone/widgets/imageavatar_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final auth = FirebaseAuth.instance;

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

  // 스토리 페이지를 열 때 uid를 사용
  void _openStoryPage(String uid) {
    context.pushTransparentRoute(
      StoryPage(uid: uid),
      transitionDuration: Duration(milliseconds: 100),
      reverseTransitionDuration: Duration(milliseconds: 100),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              GestureDetector(
                onTap: () => _openStoryPage(currentUser!.uid), // 내 uid로 설정
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
                  child: ImageAvatar(
                    size: 80,
                    type: Shape.MYSTORY,
                  ),
                ),
              ),
              Text(
                '내 스토리',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: grey50,
                ),
              ),
            ],
          ),
          ...List.generate(
            userInfo.length,
            (index) => GestureDetector(
              onTap: () => _openStoryPage(userInfo[index]['uid']!), // uid 사용
              child: SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
                      child: ImageAvatar(
                        size: 80,
                        imageUrl: userInfo[index]['profileImage'],
                        type: Shape.STORY,
                      ),
                    ),
                    Text(
                      userInfo[index]['name'] ?? 'user$index',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: grey80,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
