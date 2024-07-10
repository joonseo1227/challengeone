import 'package:challengeone/config/color.dart';
import 'package:challengeone/widgets/imageavatar.dart';
import 'package:flutter/material.dart';

class Stories extends StatefulWidget {
  const Stories({super.key});

  @override
  State<Stories> createState() => _StoriesState();
}

class _StoriesState extends State<Stories> {
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
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
                child: ImageAvatar(
                  size: 80,
                  type: Shape.MYSTORY,
                ),
              ),
              Text(
                '내 스토리',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: grey60,
                ),
              ),
            ],
          ),
          ...List.generate(
            20,
            (index) => SizedBox(
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 64),
                    child: Text(
                      'user$index',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: grey80,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
