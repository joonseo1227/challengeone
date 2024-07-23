import 'package:challengeone/config/color.dart';
import 'package:challengeone/pages/add_challenge_page.dart';
import 'package:challengeone/pages/people_page.dart';
import 'package:challengeone/pages/settings_page.dart';
import 'package:challengeone/widgets/challenges.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          user?.displayName ?? '게스트',
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SettingsPage()));
            },
            icon: Icon(Icons.settings),
            color: grey100,
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(16, 16, 0, 16),
            child: Row(
              children: [
                ImageAvatar(
                  size: 96,
                  type: Shape.STORY,
                ),
                Spacer(),
                Column(
                  children: [
                    Text(
                      '15',
                      style: TextStyle(
                        color: grey100,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '레벨',
                      style: TextStyle(
                        color: grey50,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PeopleTab(initialIndex: 0)));
                  },
                  child: Column(
                    children: [
                      Text(
                        '5',
                        style: TextStyle(
                          color: grey100,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '팔로워',
                        style: TextStyle(
                          color: grey50,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PeopleTab(initialIndex: 1)));
                  },
                  child: Column(
                    children: [
                      Text(
                        '5',
                        style: TextStyle(
                          color: grey100,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '팔로잉',
                        style: TextStyle(
                          color: grey50,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
          const SizedBox(
            height: 32,
          ),
          MyChallenges(),
          SizedBox(
            height: 16,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AddChallengePage()));
        },
        backgroundColor: blue50,
        shape: CircleBorder(),
        elevation: 0,
        child: Icon(
          Icons.add,
          color: white,
        ),
      ),
    );
  }
}
