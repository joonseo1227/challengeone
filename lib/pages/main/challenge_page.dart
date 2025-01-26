import 'package:challengeone/widgets/challenges_widget.dart';
import 'package:flutter/material.dart';

class ChallengeTab extends StatelessWidget {
  const ChallengeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('챌린지'),
      ),
      body: ListView(
        children: const <Widget>[
          AllChallenges(),
          SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}
