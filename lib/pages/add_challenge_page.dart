import 'package:challengeone/config/color.dart';
import 'package:challengeone/widgets/button.dart';
import 'package:challengeone/widgets/textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final auth = FirebaseAuth.instance;

class AddChallengePage extends StatefulWidget {
  @override
  State<AddChallengePage> createState() => _AddChallengePageState();
}

class _AddChallengePageState extends State<AddChallengePage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TextEditingController _challengeNameController =
      TextEditingController();
  final TextEditingController _challengeGoalController =
      TextEditingController();
  final TextEditingController _challengeDescriptionController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('새 챌린지'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              CustomTextField(
                backgroundColor: white,
                label: "챌린지 이름",
                controller: _challengeNameController,
              ),
              const SizedBox(
                height: 16,
              ),
              CustomTextField(
                backgroundColor: white,
                label: "챌린지 목표",
                controller: _challengeGoalController,
              ),
              const SizedBox(
                height: 16,
              ),
              CustomTextField(
                backgroundColor: white,
                label: "챌린지 설명",
                controller: _challengeDescriptionController,
              ),
              const SizedBox(
                height: 16,
              ),
              PrimaryButton(
                text: "챌린지 추가",
                onTap: () {
                  if (auth.currentUser?.uid != null) {
                    firestore.collection('challenge').doc().set({
                      'challengeDescription':
                          _challengeDescriptionController.text,
                      'challengeGoal': _challengeGoalController.text,
                      'challengeName': _challengeNameController.text,
                      'uid': auth.currentUser?.uid,
                    });
                  } else {
                    firestore.collection('challenge').doc().set({
                      'challengeDescription':
                          _challengeDescriptionController.text,
                      'challengeGoal': _challengeGoalController.text,
                      'challengeName': _challengeNameController.text,
                      'uid': 'guest',
                    });
                  }
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
