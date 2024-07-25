import 'package:challengeone/providers/story_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';

final auth = FirebaseAuth.instance;

class StoryPage extends StatefulWidget {
  final String uid;

  const StoryPage({Key? key, required this.uid}) : super(key: key);

  @override
  _StoryPageState createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  late StoryController storyController;
  late PageController pageController;
  late User? currentUser;

  // 사용자 스토리 리스트
  List<List<StoryItem>> userStories = [];

  // 사용자 이름과 프로필 이미지 URL 리스트
  List<Map<String, String>> userInfo = [];

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    storyController = StoryController();
    pageController = PageController();

    // Firestore에서 데이터 가져오기
    _loadUserInfo();
  }

  // Firestore에서 사용자 정보를 비동기로 가져오는 함수
  Future<void> _loadUserInfo() async {
    StoryProvider storyProvider =
        StoryProvider(firebaseFirestore: FirebaseFirestore.instance);

    List<Map<String, String>> fetchedUserInfo =
        await storyProvider.getUserInfo();

    setState(() {
      userInfo = fetchedUserInfo;
    });

    // 사용자 스토리 로드
    List<List<StoryItem>> fetchedUserStories =
        await storyProvider.getUserStories();

    setState(() {
      userStories = fetchedUserStories;
    });
  }

  @override
  void dispose() {
    storyController.dispose();
    pageController.dispose();
    super.dispose();
  }

  void _goToNextUser() {
    if (pageController.page!.toInt() < userInfo.length - 1) {
      pageController.nextPage(
        duration: Duration(milliseconds: 100),
        curve: Curves.easeIn,
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: DismissiblePage(
          direction: DismissiblePageDismissDirection.multi,
          isFullScreen: true,
          onDismissed: () {
            Navigator.of(context).pop();
          },
          child: userInfo.isEmpty || userStories.isEmpty
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : PageView.builder(
                  controller: pageController,
                  itemCount: userInfo.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        StoryView(
                          indicatorHeight: IndicatorHeight.small,
                          storyItems: userStories[index],
                          onComplete: _goToNextUser,
                          progressPosition: ProgressPosition.top,
                          repeat: false,
                          controller: storyController,
                        ),
                        Positioned(
                          top: 24.0,
                          left: 16.0,
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(
                                  userInfo[index]["profileImage"]!,
                                ),
                              ),
                              SizedBox(width: 10.0),
                              Text(
                                userInfo[index]["name"]!,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
        ),
      ),
    );
  }
}
