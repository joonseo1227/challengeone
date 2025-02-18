import 'package:challengeone/models/theme_model.dart';
import 'package:challengeone/pages/main/profile_page.dart';
import 'package:challengeone/providers/theme_provider.dart';
import 'package:challengeone/widgets/c_search_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final auth = FirebaseAuth.instance;

class PeopleSearchPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<PeopleSearchPage> createState() => _PeopleSearchPageState();
}

class _PeopleSearchPageState extends ConsumerState<PeopleSearchPage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TextEditingController _searchController = TextEditingController();
  List<QueryDocumentSnapshot> _searchResults = [];
  bool _noResultsFound = false;

  void _searchPeople(String searchText) async {
    searchText = searchText.trim().toLowerCase();
    if (searchText.isNotEmpty) {
      String endText = searchText.substring(0, searchText.length - 1) +
          String.fromCharCode(searchText.codeUnitAt(searchText.length - 1) + 1);

      var results = await firestore
          .collection('user')
          .where('name', isGreaterThanOrEqualTo: searchText)
          .where('name', isLessThan: endText)
          .get();

      setState(() {
        _searchResults = results.docs;
        _noResultsFound = _searchResults.isEmpty;
      });
    } else {
      setState(() {
        _searchResults = [];
        _noResultsFound = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: CSearchBar(
          controller: _searchController,
          hint: '검색',
          onSubmitted: _searchPeople, // 함수 참조 전달
        ),
      ),
      body: _buildSearchResults(),
    );
  }

  Widget _buildSearchResults() {
    final isDarkMode = ref.watch(themeProvider);

    if (_noResultsFound) {
      return Center(
        child: Text(
          '검색 결과가 없습니다.',
          style: TextStyle(
            fontSize: 16,
            color: ThemeModel.sub5(isDarkMode),
          ),
        ),
      );
    } else if (_searchResults.isEmpty) {
      return Center(
        child: Text(
          '검색어를 입력하세요.',
          style: TextStyle(
            fontSize: 16,
            color: ThemeModel.sub5(isDarkMode),
          ),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          var user = _searchResults[index];

          // ListTile을 반환하는 위젯
          Widget listTile = ListTile(
            leading: CircleAvatar(
              backgroundImage:
                  NetworkImage(user['profileImageUrl']), // 프로필 이미지 URL 사용
            ),
            title: Text(user['name']),
            onTap: () {
              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (context) => ProfileTab(
                    uid: user['uid'],
                  ),
                ),
              );
            },
          );

          // 마지막 항목이 아니면 Divider를 추가
          if (index < _searchResults.length - 1) {
            return Column(
              children: [
                listTile,
                const Divider(), // 항목 사이에 Divider 추가
              ],
            );
          } else {
            return listTile; // 마지막 항목에는 Divider 추가하지 않음
          }
        },
      );
    }
  }
}
