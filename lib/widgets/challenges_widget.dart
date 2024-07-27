import 'package:challengeone/config/color.dart';
import 'package:challengeone/models/challenge.dart';
import 'package:challengeone/providers/challenge_provider.dart';
import 'package:challengeone/widgets/listtitle_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserChallenges extends StatefulWidget {
  final String uid;

  const UserChallenges({Key? key, required this.uid}) : super(key: key);

  @override
  State<UserChallenges> createState() => _UserChallengesState();
}

class _UserChallengesState extends State<UserChallenges> {
  final ChallengeProvider firebaseDB =
      ChallengeProvider(firebaseFirestore: FirebaseFirestore.instance);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StreamBuilder<List<Challenge>>(
          stream: firebaseDB.getChallenges(widget.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  '오류가 발생했어요: ${snapshot.error}',
                  style: const TextStyle(
                    color: grey60,
                    fontSize: 16,
                  ),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
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
                physics: const NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final challenge = snapshot.data![index];
                  return Column(
                    children: [
                      ListTile(
                        title: Text(challenge.challengeName),
                        subtitle: Text(challenge.challengeGoal),
                        trailing: const Icon(Icons.check_circle_outline),
                      ),
                      if (index != snapshot.data!.length - 1) const Divider(),
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
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  '오류가 발생했어요: ${snapshot.error}',
                  style: const TextStyle(
                    color: grey60,
                    fontSize: 16,
                  ),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
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
                physics: const NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final challenge = snapshot.data![index];
                  return Column(
                    children: [
                      ListTile(
                        title: Text(challenge.challengeName),
                        subtitle: Text(challenge.challengeGoal),
                        trailing: const Icon(Icons.check_circle_outline),
                      ),
                      if (index != snapshot.data!.length - 1) const Divider(),
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
