import 'package:challengeone/widgets/challenges.dart';
import 'package:challengeone/widgets/stories.dart';
import 'package:flutter/material.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Challenge One'),
      ),
      body: ListView(
        children: <Widget>[
          Stories(),
          SizedBox(
            height: 80,
          ),
          MyChallenges(),
          SizedBox(
            height: 80,
          ),
          AllChallenges(),
          SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}
