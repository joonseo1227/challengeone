import 'package:challengeone/models/theme_model.dart';
import 'package:challengeone/pages/story_page.dart';
import 'package:challengeone/providers/theme_provider.dart';
import 'package:challengeone/widgets/imageavatar_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final auth = FirebaseAuth.instance;
final firestore = FirebaseFirestore.instance;

class Stories extends ConsumerStatefulWidget {
  const Stories({super.key});

  @override
  ConsumerState<Stories> createState() => _StoriesState();
}

class _StoriesState extends ConsumerState<Stories> {
  List<Map<String, String>> userInfo = [];
  bool isLoading = true;
  late User? currentUser;

  @override
  void initState() {
    currentUser = FirebaseAuth.instance.currentUser;
    super.initState();
  }

  int _findMyIndex(String uid) {
    return userInfo.indexWhere((user) => user['uid'] == uid);
  }

  void _openStoryPage(int select) {
    final uidList = userInfo.map((user) => user['uid'] ?? 'guest').toList();

    context.pushTransparentRoute(
      StoryPage(uidList: uidList, initIndex: select),
      transitionDuration: const Duration(milliseconds: 100),
      reverseTransitionDuration: const Duration(milliseconds: 100),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);

    return StreamBuilder<QuerySnapshot>(
      stream: firestore.collection('user').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('데이터를 불러오는 중 오류가 발생했습니다.'));
        }

        userInfo = snapshot.data!.docs.map((doc) {
          if (doc.exists) {
            return {
              "name": doc['name'] as String? ?? 'Unknown',
              "profileImageUrl": doc['profileImageUrl'] as String? ?? '',
              "uid": doc['uid'] as String? ?? '',
            };
          } else {
            return {
              "name": 'Unknown',
              "profileImageUrl": '',
              "uid": '',
            };
          }
        }).toList();

        if (userInfo.isEmpty || _findMyIndex(currentUser!.uid) == -1) {
          return const Center(child: Text('사용자 데이터를 불러올 수 없습니다.'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      int myIndex = _findMyIndex(currentUser!.uid);
                      if (myIndex != -1) _openStoryPage(myIndex);
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
                      child: ImageAvatar(
                        imageUrl: userInfo[_findMyIndex(currentUser!.uid)]
                                ['profileImageUrl'] ??
                            '',
                        size: 80,
                        type: Shape.MYSTORY,
                      ),
                    ),
                  ),
                  Text(
                    '내 스토리',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: ThemeModel.sub5(isDarkMode),
                    ),
                  ),
                ],
              ),
              ...userInfo
                  .where((user) => user['uid'] != currentUser!.uid)
                  .map((user) {
                int index = userInfo.indexOf(user);
                return GestureDetector(
                  onTap: () => _openStoryPage(index),
                  child: SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
                          child: ImageAvatar(
                            size: 80,
                            imageUrl: user['profileImageUrl'],
                            type: Shape.STORY,
                          ),
                        ),
                        Text(
                          user['name'] ?? 'user$index',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: ThemeModel.text(isDarkMode),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
