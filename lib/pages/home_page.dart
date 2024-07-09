import 'package:challengeone/config/font.dart';
import 'package:challengeone/pages/challenge_page.dart';
import 'package:challengeone/pages/friends_page.dart';
import 'package:challengeone/pages/notifications_page.dart';
import 'package:challengeone/pages/profile_page.dart';
import 'package:challengeone/widgets/stories.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static List<String> _tabTitles = <String>[
    '홈',
    '챌린지',
    '친구',
    '알림',
    '프로필',
  ];

  static List<Widget> _widgetOptions = <Widget>[
    HomeTab(),
    ChallengeTab(),
    FriendsTab(),
    NotificationsTab(),
    ProfileTab(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _tabTitles[_selectedIndex],
        ),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: _tabTitles[0],
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flag),
            label: _tabTitles[1],
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: _tabTitles[2],
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: _tabTitles[3],
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: _tabTitles[4],
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Stories(),
        ListTitle(
          title: '오늘의 챌린지',
          subtitle: '오늘의 목표를 완료하고 보상을 받으세요',
        ),
        ListTile(
          title: Text('아침 달리기'),
          subtitle: Text('30분 달리기'),
          trailing: Icon(Icons.check_circle, color: Colors.green),
        ),
        Divider(),
        ListTile(
          title: Text('독서'),
          subtitle: Text('10페이지 읽기'),
          trailing: Icon(Icons.check_circle_outline),
        ),
        SizedBox(
          height: 64,
        ),
        ListTitle(
          title: '오늘의 챌린지',
          subtitle: '오늘의 목표를 완료하고 보상을 받으세요',
        ),
        ListTile(
          title: Text('아침 달리기'),
          subtitle: Text('30분 달리기'),
          trailing: Icon(Icons.check_circle, color: Colors.green),
        ),
        Divider(),
        ListTile(
          title: Text('독서'),
          subtitle: Text('10페이지 읽기'),
          trailing: Icon(Icons.check_circle_outline),
        ),
        Divider(),
        ListTile(
          title: Text('독서'),
          subtitle: Text('10페이지 읽기'),
          trailing: Icon(Icons.check_circle_outline),
        ),
        Divider(),
        ListTile(
          title: Text('독서'),
          subtitle: Text('10페이지 읽기'),
          trailing: Icon(Icons.check_circle_outline),
        ),
        SizedBox(
          height: 64,
        ),
      ],
    );
  }
}

class ListTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  ListTitle({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Fonts.title, // Assuming Fonts.title is defined elsewhere
          ),
          Text(
            subtitle,
            style:
                Fonts.subtitle, // Assuming Fonts.subtitle is defined elsewhere
          ),
        ],
      ),
    );
  }
}
