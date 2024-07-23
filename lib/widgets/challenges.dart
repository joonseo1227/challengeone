import 'package:challengeone/config/color.dart';
import 'package:challengeone/models/challenge.dart';
import 'package:challengeone/pages/login_page.dart';
import 'package:challengeone/providers/challenge_provider.dart';
import 'package:challengeone/widgets/button.dart';
import 'package:challengeone/widgets/listtitle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyChallenges extends StatefulWidget {
  const MyChallenges({super.key});

  @override
  State<MyChallenges> createState() => _MyChallengesState();
}

class _MyChallengesState extends State<MyChallenges> {
  final ChallengeProvider firebaseDB =
      ChallengeProvider(firebaseFirestore: FirebaseFirestore.instance);

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Center(
        child: Column(
          children: [
            Text(
              '내 챌린지를 확인하려면 로그인하세요',
              style: TextStyle(
                color: grey60,
                fontSize: 16,
              ),
            ),
            Container(
              child: Container(
                child: Container(
                  width: 80,
                  child: GhostButton(
                    text: "로그인",
                    onTap: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => LoginPage()),
                        (route) => false,
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTitle(
          title: '내 챌린지',
          subtitle: '오늘의 목표를 완료하고 보상을 받으세요',
        ),
        StreamBuilder<List<Challenge>>(
          stream: firebaseDB.getChallenges(user.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  '오류가 발생했어요: ${snapshot.error}',
                  style: TextStyle(
                    color: grey60,
                    fontSize: 16,
                  ),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  '챌린지가 없어요',
                  style: TextStyle(
                    color: grey60,
                    fontSize: 16,
                  ),
                ),
              );
            } else {
              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final challenge = snapshot.data![index];
                  return Column(
                    children: [
                      ListTile(
                        title: Text(challenge.challengeName),
                        subtitle: Text(challenge.challengeGoal),
                        trailing: Icon(Icons.check_circle_outline),
                      ),
                      if (index != snapshot.data!.length - 1) Divider(),
                    ],
                  );
                },
              );
            }
          },
        ),
      ],
    );
  }
}

class AllChallenges extends StatefulWidget {
  const AllChallenges({super.key});

  @override
  State<AllChallenges> createState() => _AllChallengesState();
}

class _AllChallengesState extends State<AllChallenges> {
  final ChallengeProvider firebaseDB =
      ChallengeProvider(firebaseFirestore: FirebaseFirestore.instance);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTitle(
          title: '전체 챌린지',
          subtitle: '모든 사용자의 챌린지를 확인하세요',
        ),
        StreamBuilder<List<Challenge>>(
          stream: firebaseDB.getAllChallenges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  '오류가 발생했어요: ${snapshot.error}',
                  style: TextStyle(
                    color: grey60,
                    fontSize: 16,
                  ),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  '챌린지가 없어요',
                  style: TextStyle(
                    color: grey60,
                    fontSize: 16,
                  ),
                ),
              );
            } else {
              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final challenge = snapshot.data![index];
                  return Column(
                    children: [
                      ListTile(
                        title: Text(challenge.challengeName),
                        subtitle: Text(challenge.challengeGoal),
                        trailing: Icon(Icons.check_circle_outline),
                      ),
                      if (index != snapshot.data!.length - 1) Divider(),
                    ],
                  );
                },
              );
            }
          },
        ),
      ],
    );
  }
}
