import 'package:challengeone/config/color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PeopleTab extends StatefulWidget {
  final int initialIndex;

  PeopleTab({this.initialIndex = 0}); // 기본값은 0으로 설정

  @override
  State<PeopleTab> createState() => _PeopleTabState();
}

class _PeopleTabState extends State<PeopleTab> with TickerProviderStateMixin {
  final User? user = FirebaseAuth.instance.currentUser;
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialIndex,
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            user?.displayName ?? '게스트',
          ),
          bottom: TabBar(
            controller: tabController,
            tabs: const [
              Tab(
                child: Text(
                  '팔로워 5명',
                ),
              ),
              Tab(
                child: Text(
                  '팔로잉 5명',
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: tabController,
          children: [
            ListView(
              children: <Widget>[
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage('assets/images/user1.png'),
                  ),
                  title: Text('신유'),
                  subtitle: Text('챌린지 5개 성공'),
                  trailing: Icon(Icons.check_circle, color: green40),
                ),
                Divider(),
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage('assets/images/user1.png'),
                  ),
                  title: Text('도훈'),
                  subtitle: Text('챌린지 3개 성공'),
                  trailing: Icon(Icons.check_circle_outline),
                ),
                Divider(),
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage('assets/images/user1.png'),
                  ),
                  title: Text('영재'),
                  subtitle: Text('챌린지 3개 성공'),
                  trailing: Icon(Icons.check_circle_outline),
                ),
                Divider(),
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage('assets/images/user1.png'),
                  ),
                  title: Text('한진'),
                  subtitle: Text('챌린지 3개 성공'),
                  trailing: Icon(Icons.check_circle_outline),
                ),
                Divider(),
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage('assets/images/user1.png'),
                  ),
                  title: Text('경민'),
                  subtitle: Text('챌린지 3개 성공'),
                  trailing: Icon(Icons.check_circle_outline),
                ),
                SizedBox(
                  height: 16,
                ),
              ],
            ),
            ListView(
              children: <Widget>[
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage('assets/images/user1.png'),
                  ),
                  title: Text('신유'),
                  subtitle: Text('챌린지 5개 성공'),
                  trailing: Icon(Icons.check_circle, color: green40),
                ),
                Divider(),
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage('assets/images/user1.png'),
                  ),
                  title: Text('도훈'),
                  subtitle: Text('챌린지 3개 성공'),
                  trailing: Icon(Icons.check_circle_outline),
                ),
                Divider(),
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage('assets/images/user1.png'),
                  ),
                  title: Text('영재'),
                  subtitle: Text('챌린지 3개 성공'),
                  trailing: Icon(Icons.check_circle_outline),
                ),
                Divider(),
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage('assets/images/user1.png'),
                  ),
                  title: Text('한진'),
                  subtitle: Text('챌린지 3개 성공'),
                  trailing: Icon(Icons.check_circle_outline),
                ),
                Divider(),
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage('assets/images/user1.png'),
                  ),
                  title: Text('경민'),
                  subtitle: Text('챌린지 3개 성공'),
                  trailing: Icon(Icons.check_circle_outline),
                ),
                SizedBox(
                  height: 16,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
