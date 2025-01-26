import 'package:challengeone/pages/main/challenge_page.dart';
import 'package:challengeone/pages/main/home_page.dart';
import 'package:challengeone/pages/main/notifications_page.dart';
import 'package:challengeone/pages/main/people_page.dart';
import 'package:challengeone/pages/main/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0; // 현재 선택된 탭의 인덱스
  late User? currentUser; // 현재 로그인한 사용자 정보를 담을 변수

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser; // 현재 사용자의 정보를 초기화
  }

  // 탭이 선택될 때 호출되는 함수
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // 선택된 인덱스를 상태에 반영
    });
  }

  @override
  Widget build(BuildContext context) {
    // 각 탭에 대응하는 페이지들
    List<Widget> _pages = <Widget>[
      HomeTab(), // 홈 페이지
      ChallengeTab(), // 챌린지 페이지
      PeopleTab(uid: currentUser?.uid ?? ''), // 사람들 페이지, 사용자 UID를 전달
      NotificationsTab(), // 알림 페이지
      ProfileTab(uid: currentUser?.uid ?? ''), // 프로필 페이지, 사용자 UID를 전달
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex, // 현재 선택된 페이지를 보여줌
        children: _pages, // 페이지 리스트
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // 고정된 타입의 네비게이션 바
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flag),
            label: '챌린지',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: '사람들',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: '알림',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '프로필',
          ),
        ],
        currentIndex: _selectedIndex, // 현재 선택된 인덱스
        onTap: _onItemTapped, // 탭이 선택될 때 호출될 함수
      ),
    );
  }
}
