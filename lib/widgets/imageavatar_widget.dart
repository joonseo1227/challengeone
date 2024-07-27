import 'package:challengeone/config/color.dart';
import 'package:challengeone/pages/add_story_page.dart';
import 'package:flutter/material.dart';

enum Shape { ON, OFF, STORY, MYSTORY }

class ImageAvatar extends StatelessWidget {
  final double size;
  final Shape type;
  final void Function()? onTap;
  final String? imageUrl; // 이미지 URL 추가

  const ImageAvatar({
    super.key,
    this.size = 80,
    required this.type,
    this.onTap,
    this.imageUrl, // 이미지 URL 초기화
  });

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case Shape.STORY:
        return _storyAvatar(context);
      case Shape.ON:
        return _onAvatar();
      case Shape.OFF:
        return _offAvatar();
      case Shape.MYSTORY:
        return _myStoryAvatar(context);
    }
  }

  // 기본 아바타 위젯, 이미지가 있으면 이미지를 사용하고 없으면 기본 아이콘을 사용
  Widget _basicAvatar() {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: const BoxDecoration(color: white, shape: BoxShape.circle),
      child: CircleAvatar(
        radius: size / 2,
        backgroundImage: imageUrl != null
            ? NetworkImage(imageUrl!) // 이미지 URL을 사용하는 경우
            : const AssetImage('assets/images/user1.png')
                as ImageProvider, // 기본 아이콘을 사용하는 경우
      ),
    );
  }

  // 스토리 아바타 위젯
  Widget _storyAvatar(BuildContext context) {
    return Container(
      height: size + 3,
      width: size + 3,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        // 스토리 영역의 테두리를 그라데이션으로 설정
        gradient: LinearGradient(
          // 시작 방향 지정
          begin: Alignment.bottomLeft,
          // 종료 방향 지정
          end: Alignment.topRight,
          colors: [
            purple60,
            blue50,
            teal30,
          ],
        ),
      ),
      child: Container(
        margin: const EdgeInsets.all(3),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: white,
        ),
        child: _basicAvatar(),
      ),
    );
  }

  // 온라인 상태 아바타 위젯
  Widget _onAvatar() {
    return Container(
      height: size + 3,
      width: size + 3,
      padding: const EdgeInsets.all(3),
      decoration: const BoxDecoration(
        color: black,
        shape: BoxShape.circle,
      ),
      child: _basicAvatar(),
    );
  }

  // 오프라인 상태 아바타 위젯
  Widget _offAvatar() {
    return Container(
      height: size + 3,
      width: size + 3,
      padding: const EdgeInsets.all(3),
      decoration: const BoxDecoration(
        color: white,
        shape: BoxShape.circle,
      ),
      child: _basicAvatar(),
    );
  }

  // 내 스토리 아바타 위젯
  Widget _myStoryAvatar(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          _storyAvatar(context),
          Positioned(
            // 위치 설정
            bottom: 0.5, // 하단부
            right: 0.5, // 우측
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AddStoryPage()));
              },
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: grey10,
                ),
                child: Container(
                  width: 20,
                  height: 20,
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: blue50,
                  ),
                  child: const Icon(
                    size: 16,
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
