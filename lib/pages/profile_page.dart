import 'package:challengeone/config/color.dart';
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
            padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
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
                      user?.displayName ?? '게스트',
                      style: TextStyle(
                        color: grey100,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '레벨 10\n친구 5명',
                      style: TextStyle(
                        color: grey50,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 32,
          ),
          BasicChallenges(),
          SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}
