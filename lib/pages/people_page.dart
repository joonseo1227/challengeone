import 'package:challengeone/config/color.dart';
import 'package:challengeone/pages/people_search_page.dart';
import 'package:challengeone/pages/profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  int followersCount = 0;
  int followingCount = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialIndex,
    );
    _fetchCounts();
  }

  Future<void> _fetchCounts() async {
    if (user != null) {
      var followersSnapshot = await FirebaseFirestore.instance
          .collection('following')
          .doc(user!.uid)
          .collection('userFollowers')
          .get();
      var followingSnapshot = await FirebaseFirestore.instance
          .collection('following')
          .doc(user!.uid)
          .collection('userfollowing')
          .get();

      setState(() {
        followersCount = followersSnapshot.size;
        followingCount = followingSnapshot.size;
        isLoading = false;
      });
    }
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
          title: Text(user?.displayName ?? '게스트'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(user?.displayName ?? '게스트'),
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
          .doc(user!.uid)
          .collection('userFollowers')
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('팔로워가 없어요'));
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
          .doc(user!.uid)
          .collection('userfollowing')
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('팔로잉이 없어요'));
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
          return ListTile(title: Text('로딩 중...'));
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
