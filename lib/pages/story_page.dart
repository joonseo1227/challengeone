import 'package:challengeone/widgets/tabbar.dart';
import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';

class StoryPage extends StatefulWidget {
  final int userIndex;

  const StoryPage({Key? key, required this.userIndex}) : super(key: key);

  @override
  _StoryPageState createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  late StoryController storyController;
  late int currentUserIndex;
  late int currentStoryIndex;

  // 유저별 스토리 목록
  late List<List<StoryItem>> userStories;

  // 유저 이름과 프로필 이미지 URL 목록
  final List<Map<String, String>> userInfo = [
    {
      "name": "User 1",
      "profileImage":
          "https://www.example.com/user1_profile.jpg", // replace with actual URL
    },
    {
      "name": "User 2",
      "profileImage":
          "https://www.example.com/user2_profile.jpg", // replace with actual URL
    },
    {
      "name": "User 3",
      "profileImage":
          "https://www.example.com/user3_profile.jpg", // replace with actual URL
    },
    {
      "name": "User 4",
      "profileImage":
          "https://www.example.com/user4_profile.jpg", // replace with actual URL
    },
  ];

  @override
  void initState() {
    super.initState();
    currentUserIndex = widget.userIndex;
    currentStoryIndex = 0;
    storyController = StoryController();

    // 스토리 초기화
    userStories = [
      [
        StoryItem.text(
          title: "1-1",
          backgroundColor: Colors.blue,
        ),
        StoryItem.pageImage(
          url:
              "https://image.ibb.co/cU4WGx/Omotuo-Groundnut-Soup-braperucci-com-1.jpg",
          caption: Text(
            "1-2",
            style: TextStyle(
              fontSize: 15,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          controller: storyController,
        ),
      ],
      [
        StoryItem.text(
          title: "2-1",
          backgroundColor: Colors.red,
          textStyle: TextStyle(
            fontFamily: 'Dancing',
            fontSize: 40,
          ),
        ),
        StoryItem.pageImage(
          url: "https://media.giphy.com/media/5GoVLqeAOo6PK/giphy.gif",
          caption: Text(
            "2-2",
            style: TextStyle(
              fontSize: 15,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          controller: storyController,
        ),
      ],
      [
        StoryItem.text(
          title: "3-1",
          backgroundColor: Colors.yellow,
          textStyle: TextStyle(
            fontFamily: 'Dancing',
            fontSize: 40,
          ),
        ),
        StoryItem.pageImage(
          url: "https://media.giphy.com/media/5GoVLqeAOo6PK/giphy.gif",
          caption: Text(
            "3-2",
            style: TextStyle(
              fontSize: 15,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          controller: storyController,
        ),
        StoryItem.text(
          title: "3-3",
          backgroundColor: Colors.white,
          textStyle: TextStyle(
            fontFamily: 'Dancing',
            fontSize: 40,
          ),
        ),
      ],
      [
        StoryItem.text(
          title: "4-1",
          backgroundColor: Colors.green,
          textStyle: TextStyle(
            fontFamily: 'Dancing',
            fontSize: 40,
          ),
        ),
        StoryItem.pageImage(
          url: "https://media.giphy.com/media/5GoVLqeAOo6PK/giphy.gif",
          caption: Text(
            "4-2",
            style: TextStyle(
              fontSize: 15,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          controller: storyController,
        ),
      ],
    ];
  }

  @override
  void dispose() {
    storyController.dispose();
    super.dispose();
  }

  void _goToNextUser() {
    if (currentUserIndex < userStories.length - 1) {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return StoryPage(userIndex: currentUserIndex + 1);
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        ),
      );
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => MainPage()),
          (route) => false);
    }
  }

  void _goToPreviousUser() {
    if (currentUserIndex > 0) {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return StoryPage(userIndex: currentUserIndex - 1);
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(-1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity != null) {
                if (details.primaryVelocity! < 0) {
                  _goToNextUser(); // 오른쪽에서 왼쪽으로 스와이프
                } else if (details.primaryVelocity! > 0) {
                  _goToPreviousUser(); // 왼쪽에서 오른쪽으로 스와이프
                }
              }
            },
            child: StoryView(
              onVerticalSwipeComplete: (direction) {
                if (direction == Direction.down) {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => MainPage()),
                      (route) => false);
                }
              },
              storyItems: userStories[currentUserIndex],
              onStoryShow: (storyItem, index) {
                currentStoryIndex = index;
              },
              onComplete: () {
                print("Completed a cycle");
                _goToNextUser();
              },
              progressPosition: ProgressPosition.top,
              repeat: false,
              controller: storyController,
            ),
          ),
          Positioned(
            top: 64.0,
            left: 16.0,
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage:
                      NetworkImage(userInfo[currentUserIndex]["profileImage"]!),
                ),
                SizedBox(width: 10.0),
                Text(
                  userInfo[currentUserIndex]["name"]!,
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
      ),
    );
  }
}
