import 'package:challengeone/config/color.dart';
import 'package:challengeone/pages/people_search_page.dart';
import 'package:challengeone/pages/profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PeopleTab extends StatefulWidget {
  final int initialIndex;
  final String uid; // 유저 ID 추가

  const PeopleTab(
      {this.initialIndex = 0, required this.uid}); // 기본값은 0으로 설정하고 uid 필수로 받음

  @override
  State<PeopleTab> createState() => _PeopleTabState();
}

class _PeopleTabState extends State<PeopleTab> with TickerProviderStateMixin {
  late TabController tabController;
  int followersCount = 0;
  int followingCount = 0;
  bool isLoading = true;
  String userName = ''; // 유저 이름을 저장할 변수 추가

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialIndex,
    );
    _fetchCounts();
    _fetchUserName(); // 유저 이름을 불러오는 메서드 호출
  }

  Future<void> _fetchCounts() async {
    var followersSnapshot = await FirebaseFirestore.instance
        .collection('following')
        .doc(widget.uid)
        .collection('userFollowers')
        .get();
    var followingSnapshot = await FirebaseFirestore.instance
        .collection('following')
        .doc(widget.uid)
        .collection('userfollowing')
        .get();

    setState(() {
      followersCount = followersSnapshot.size;
      followingCount = followingSnapshot.size;
      isLoading = false;
    });
  }

  Future<void> _fetchUserName() async {
    var userDoc = await FirebaseFirestore.instance
        .collection('user')
        .doc(widget.uid)
        .get();
    setState(() {
      userName = userDoc['name']; // 유저 이름 설정
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('로드 중...'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(userName), // 유저 이름 표시
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PeopleSearchPage()));
              },
              icon: Icon(Icons.search),
              color: grey100,
            )
          ],
          bottom: TabBar(
            controller: tabController,
            tabs: [
              Tab(
                child: Text('팔로워 $followersCount명'),
              ),
              Tab(
                child: Text('팔로잉 $followingCount명'),
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: tabController,
          children: [
            _buildFollowerList(),
            _buildFollowingList(),
          ],
        ),
      ),
    );
  }

  Widget _buildFollowerList() {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('following')
          .doc(widget.uid)
          .collection('userFollowers')
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('팔로워가 없어요'));
        }
        return ListView(
          children: snapshot.data!.docs.map((doc) {
            return _buildUserTile(doc.id);
          }).toList(),
        );
      },
    );
  }

  Widget _buildFollowingList() {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('following')
          .doc(widget.uid)
          .collection('userfollowing')
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('팔로잉이 없어요'));
        }
        return ListView(
          children: snapshot.data!.docs.map((doc) {
            return _buildUserTile(doc.id);
          }).toList(),
        );
      },
    );
  }

  Widget _buildUserTile(String uid) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('user').doc(uid).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const ListTile(title: Text('로딩 중...'));
        }
        var user = snapshot.data!;
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(user['profileImage']),
          ),
          title: Text(user['name']),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ProfileTab(uid: user.id),
              ),
            );
          },
        );
      },
    );
  }
}
