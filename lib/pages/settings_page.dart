import 'package:challengeone/pages/login_page.dart';
import 'package:challengeone/widgets/button.dart';
import 'package:challengeone/widgets/dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('설정'),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: SecondaryButton(
              text: "로그아웃",
              onTap: () async {
                await FirebaseAuth.instance.signOut();

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return DialogUI(
                      title: '로그아웃',
                      content: '정말 로그아웃할까요?',
                      buttons: [
                        DialogButtonData(
                            text: '취소',
                            onTap: () {
                              Navigator.of(context).pop();
                            }),
                        DialogButtonData(
                            text: '로그아웃',
                            onTap: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()),
                                  (route) => false);
                            }),
                      ],
                      buttonAxis: Axis
                          .horizontal, // Axis.horizontal for horizontal arrangement
                    );
                  },
                );
              },
            ),
          ),
          SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}
