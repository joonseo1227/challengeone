import 'package:challengeone/config/color.dart';
import 'package:challengeone/widgets/listtitle.dart';
import 'package:challengeone/widgets/stories.dart';
import 'package:flutter/material.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Challenge One'),
      ),
      body: ListView(
        children: <Widget>[
          Stories(),
          ListTitle(
            title: '오늘의 챌린지',
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
          SizedBox(
            height: 64,
          ),
          ListTitle(
            title: '오늘의 챌린지',
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
          Divider(),
          ListTile(
            title: Text('독서'),
            subtitle: Text('10페이지 읽기'),
            trailing: Icon(Icons.check_circle_outline),
          ),
          Divider(),
          ListTile(
            title: Text('독서'),
            subtitle: Text('10페이지 읽기'),
            trailing: Icon(Icons.check_circle_outline),
          ),
          SizedBox(
            height: 64,
          ),
        ],
      ),
    );
  }
}
