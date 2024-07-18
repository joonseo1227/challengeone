import 'package:challengeone/models/challenge.dart';
import 'package:challengeone/providers/challenge_provider.dart';
import 'package:challengeone/widgets/listtitle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyChallenges extends StatefulWidget {
  const MyChallenges({super.key});

  @override
  State<MyChallenges> createState() => _MyChallengesState();
}

class _MyChallengesState extends State<MyChallenges> {
  final FirebaseDB firebaseDB =
      FirebaseDB(firebaseFirestore: FirebaseFirestore.instance);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTitle(
          title: '내 챌린지',
          subtitle: '오늘의 목표를 완료하고 보상을 받으세요',
        ),
        StreamBuilder<List<Challenge>>(
          stream: firebaseDB.getChallenges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('오류가 발생했습니다: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('챌린지가 없습니다.'));
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
