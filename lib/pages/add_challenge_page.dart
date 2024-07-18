import 'package:challengeone/config/color.dart';
import 'package:challengeone/widgets/button.dart';
import 'package:challengeone/widgets/textfield.dart';
import 'package:flutter/material.dart';

class AddChallengePage extends StatelessWidget {
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
              ),
              const SizedBox(
                height: 16,
              ),
              CustomTextField(
                backgroundColor: white,
                label: "챌린지 목표",
              ),
              const SizedBox(
                height: 16,
              ),
              CustomTextField(
                backgroundColor: white,
                label: "챌린지 설명",
              ),
              const SizedBox(
                height: 16,
              ),
              PrimaryButton(
                text: "챌린지 추가",
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
