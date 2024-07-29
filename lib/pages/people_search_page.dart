import 'package:challengeone/pages/profile_page.dart';
import 'package:challengeone/widgets/textfield_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final auth = FirebaseAuth.instance;

class PeopleSearchPage extends StatefulWidget {
  @override
  State<PeopleSearchPage> createState() => _PeopleSearchPageState();
}

class _PeopleSearchPageState extends State<PeopleSearchPage> {
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
    return Scaffold(
      appBar: AppBar(
        title: CustomSearchBar(
          controller: _searchController,
          hint: '검색',
          onSubmitted: _searchPeople, // 함수 참조 전달
        ),
      ),
      body: _buildSearchResults(),
    );
  }

  Widget _buildSearchResults() {
    if (_noResultsFound) {
      return const Center(
        child: Text('검색 결과가 없습니다.'),
      );
    } else if (_searchResults.isEmpty) {
      return const Center(
        child: Text('검색어를 입력하세요.'),
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
                MaterialPageRoute(
                  builder: (context) => ProfileTab(uid: user['uid']),
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
