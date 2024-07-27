import 'package:challengeone/widgets/challenges_widget.dart';
import 'package:challengeone/widgets/listtitle_widget.dart';
import 'package:challengeone/widgets/stories_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  late User? currentUser;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Challenge One'),
      ),
      body: ListView(
        children: <Widget>[
          const Stories(),
          const SizedBox(
            height: 80,
          ),
          ListTitle(
            title: '내 챌린지',
            subtitle: '오늘의 목표를 완료하고 보상을 받으세요',
          ),
          UserChallenges(uid: auth.currentUser!.uid),
          const SizedBox(
            height: 80,
          ),
          const AllChallenges(),
          const SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}
