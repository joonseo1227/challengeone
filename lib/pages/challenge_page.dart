import 'package:challengeone/pages/home_page.dart';
import 'package:flutter/material.dart';

class ChallengeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTitle(
          title: '인기 챌린지',
          subtitle: '많은 사용자가 도전 중인 챌린지에요',
        ),
        ListTile(
          title: Text('30일 피트니스'),
          subtitle: Text('일일 피트니스 챌린지 30일 완성하기'),
        ),
        Divider(),
        ListTile(
          title: Text('독서 챌린지'),
          subtitle: Text('일주일에 한 권 읽기'),
        ),
      ],
    );
  }
}
