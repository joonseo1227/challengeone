import 'package:challengeone/widgets/challenges.dart';
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
          BasicChallenges(),
          SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}
