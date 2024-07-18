import 'package:challengeone/config/color.dart';
import 'package:challengeone/widgets/listtitle.dart';
import 'package:flutter/material.dart';

class MyChallenges extends StatefulWidget {
  const MyChallenges({super.key});

  @override
  State<MyChallenges> createState() => _MyChallengesState();
}

class _MyChallengesState extends State<MyChallenges> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTitle(
          title: '내 챌린지',
          subtitle: '오늘의 목표를 완료하고 보상을 받으세요',
        ),
        ListTile(
          title: Text('아침 달리기'),
          subtitle: Text('30분 달리기'),
          trailing: Icon(Icons.check_circle, color: green40),
        ),
        Divider(),
        ListTile(
          title: Text('독서'),
          subtitle: Text('10페이지 읽기'),
          trailing: Icon(Icons.check_circle_outline),
        ),
      ],
    );
  }
}
