import 'package:challengeone/config/color.dart';
import 'package:challengeone/models/theme_model.dart';
import 'package:challengeone/pages/people_search_page.dart';
import 'package:challengeone/pages/main/profile_page.dart';
import 'package:challengeone/providers/theme_provider.dart';
import 'package:challengeone/widgets/c_ink_well.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PeopleTab extends ConsumerStatefulWidget {
  final int initialIndex;
  final String uid;

  const PeopleTab({
    this.initialIndex = 0,
    required this.uid,
  });

  @override
  ConsumerState<PeopleTab> createState() => _PeopleTabState();
}

class _PeopleTabState extends ConsumerState<PeopleTab>
    with TickerProviderStateMixin {
  late TabController tabController;
  bool isLoading = true;
  String userName = '';

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialIndex,
    );
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    var userDoc = await FirebaseFirestore.instance
        .collection('user')
        .doc(widget.uid)
        .get();
    setState(() {
      userName = userDoc['name'];
      isLoading = false;
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);

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
          title: Text(userName),
          actions: [
            CInkWell(
              onTap: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => PeopleSearchPage(),
                  ),
                );
              },
              child: SizedBox(
                width: 32,
                height: 32,
                child: Icon(
                  Icons.search,
                  size: 28,
                  color: ThemeModel.text(isDarkMode),
                ),
              ),
            ),
            const SizedBox(
              width: 16,
            ),
          ],
          bottom: TabBar(
            controller: tabController,
            tabs: [
              Tab(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('following')
                      .doc(widget.uid)
                      .collection('userFollowers')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text('팔로워 로딩 중...');
                    }
                    final followersCount =
                        snapshot.hasData ? snapshot.data!.size : 0;
                    return Text('팔로워 $followersCount명');
                  },
                ),
              ),
              Tab(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('following')
                      .doc(widget.uid)
                      .collection('userFollowing')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text('팔로잉 로딩 중...');
                    }
                    final followingCount =
                        snapshot.hasData ? snapshot.data!.size : 0;
                    return Text('팔로잉 $followingCount명');
                  },
                ),
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
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('following')
          .doc(widget.uid)
          .collection('userFollowers')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              '팔로워가 없어요',
              style: TextStyle(
                color: grey60,
                fontSize: 16,
              ),
            ),
          );
        }
        return ListView.separated(
          itemCount: snapshot.data!.docs.length,
          separatorBuilder: (context, index) =>
              const Divider(), // 항목 사이에 Divider를 추가합니다.
          itemBuilder: (context, index) {
            var doc = snapshot.data!.docs[index];
            return _buildUserTile(doc.id);
          },
        );
      },
    );
  }

  Widget _buildFollowingList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('following')
          .doc(widget.uid)
          .collection('userFollowing')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              '팔로잉이 없어요',
              style: TextStyle(
                color: grey60,
                fontSize: 16,
              ),
            ),
          );
        }
        return ListView.separated(
          itemCount: snapshot.data!.docs.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            var doc = snapshot.data!.docs[index];
            return _buildUserTile(doc.id);
          },
        );
      },
    );
  }

  Widget _buildUserTile(String uid) {
    return StreamBuilder<DocumentSnapshot>(
      stream:
          FirebaseFirestore.instance.collection('user').doc(uid).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const ListTile(
            title: Text(
              '로딩 중...',
              style: TextStyle(
                color: grey60,
                fontSize: 16,
              ),
            ),
          );
        }
        var user = snapshot.data!;
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(user['profileImageUrl']),
          ),
          title: Text(user['name']),
          onTap: () {
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => ProfileTab(uid: user.id),
              ),
            );
          },
        );
      },
    );
  }
}
