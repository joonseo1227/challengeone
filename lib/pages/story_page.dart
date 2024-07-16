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

  // 유저별 스토리 목록
  late List<List<StoryItem>> userStories;

  @override
  void initState() {
    super.initState();
    currentUserIndex = widget.userIndex;
    storyController = StoryController();

    // 스토리 초기화
    userStories = [
      [
        StoryItem.text(
          title: "User 1's first story",
          backgroundColor: Colors.blue,
        ),
        StoryItem.pageImage(
          url:
              "https://image.ibb.co/cU4WGx/Omotuo-Groundnut-Soup-braperucci-com-1.jpg",
          caption: Text(
            "User 1's second story",
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
          title: "User 2's first story",
          backgroundColor: Colors.red,
          textStyle: TextStyle(
            fontFamily: 'Dancing',
            fontSize: 40,
          ),
        ),
        StoryItem.pageImage(
          url: "https://media.giphy.com/media/5GoVLqeAOo6PK/giphy.gif",
          caption: Text(
            "User 2's second story",
            style: TextStyle(
              fontSize: 15,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          controller: storyController,
        ),
      ],
      // 유저 3, 4 등의 스토리 추가
    ];
  }

  @override
  void dispose() {
    storyController.dispose();
    super.dispose();
  }

  void _goToNextUser() {
    if (currentUserIndex < userStories.length - 1) {
      setState(() {
        currentUserIndex++;
      });
      storyController.previous();
    } else {
      // 모든 스토리가 끝나면
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StoryView(
        onVerticalSwipeComplete: (direction) {
          if (direction == Direction.down) {
            Navigator.pop(context);
          }
        },
        storyItems: userStories[currentUserIndex],
        onStoryShow: (storyItem, index) {
          print("Showing a story");
        },
        onComplete: () {
          print("Completed a cycle");
          _goToNextUser();
        },
        progressPosition: ProgressPosition.top,
        repeat: false,
        controller: storyController,
      ),
    );
  }
}
