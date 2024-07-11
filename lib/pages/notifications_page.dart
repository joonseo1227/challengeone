import 'package:flutter/material.dart';

class NotificationsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('알림'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('챌린지 성공!'),
            subtitle: Text('아침 달리기 챌린지를 완료했어요.'),
          ),
          Divider(),
          ListTile(
            title: Text('새 친구 요청'),
            subtitle: Text('지훈 님이 회원님에게 친구 요청을 보냈어요.'),
          ),
        ],
      ),
    );
  }
}
