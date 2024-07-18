import 'package:challengeone/config/color.dart';
import 'package:challengeone/widgets/button.dart';
import 'package:challengeone/widgets/textfield.dart';
import 'package:flutter/material.dart';

class AddStoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('새 스토리'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              CustomTextField(
                backgroundColor: white,
                label: "스토리 캡션",
              ),
              const SizedBox(
                height: 16,
              ),
              PrimaryButton(
                text: "스토리 추가",
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
