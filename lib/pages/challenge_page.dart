import 'package:challengeone/widgets/challenges.dart';
import 'package:flutter/material.dart';

class ChallengeTab extends StatelessWidget {
  const ChallengeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('챌린지'),
      ),
      body: ListView(
        children: <Widget>[
          AllChallenges(),
          SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}
