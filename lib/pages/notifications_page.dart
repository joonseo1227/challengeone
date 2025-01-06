import 'package:flutter/material.dart';

class NotificationsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('알림'),
      ),
      body: ListView(
        children: const <Widget>[
          ListTile(
            title: Text('챌린지 성공!'),
            subtitle: Text('아침 6시 기상 챌린지를 완료했어요.'),
          ),
          Divider(),
          ListTile(
            title: Text('새 팔로워'),
            subtitle: Text('도훈 님이 회원님을 팔로우하기 시작했어요.'),
          ),
          Divider(),
          ListTile(
            title: Text('새 팔로워'),
            subtitle: Text('경민 님이 회원님을 팔로우하기 시작했어요.'),
          ),
          Divider(),
          ListTile(
            title: Text('챌린지 성공!'),
            subtitle: Text('하루 1페이지 독서 챌린지를 완료했어요.'),
          ),
          Divider(),
          ListTile(
            title: Text('챌린지 성공!'),
            subtitle: Text('일기 쓰기 챌린지를 완료했어요.'),
          ),
          SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}
