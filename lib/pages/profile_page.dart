import 'package:challengeone/pages/login_page.dart';
import 'package:challengeone/widgets/button.dart';
import 'package:challengeone/widgets/dialog.dart';
import 'package:challengeone/widgets/imageavatar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileTab extends StatefulWidget {
  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Row(
            children: [
              ImageAvatar(
                size: 96,
                type: Shape.STORY,
              ),
              SizedBox(
                width: 16,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user?.displayName ?? '사용자 이름 없음',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '레벨 10\n친구 5명',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        ListTile(
          title: Text('통계'),
          subtitle: Text('15개 챌린지 성공'),
        ),
        const SizedBox(
          height: 16,
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: CustomButton(
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
      ],
    );
  }
}
