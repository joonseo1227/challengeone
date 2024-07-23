import 'package:challengeone/config/color.dart';
import 'package:challengeone/pages/story_page.dart';
import 'package:challengeone/widgets/imageavatar.dart';
import 'package:flutter/material.dart';

class Stories extends StatefulWidget {
  const Stories({super.key});

  @override
  State<Stories> createState() => _StoriesState();
}

class _StoriesState extends State<Stories> {
  void _openStoryPage(int userIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StoryPage(userIndex: userIndex),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              GestureDetector(
                onTap: () => _openStoryPage(0),
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
            20,
            (index) => GestureDetector(
              onTap: () => _openStoryPage(index + 1),
              child: SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
                      child: ImageAvatar(
                        size: 80,
                        type: Shape.STORY,
                      ),
                    ),
                    Text(
                      'user$index',
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
