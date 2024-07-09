import 'package:flutter/material.dart';

enum Shape { ON, OFF, STORY, MYSTORY }

class ImageAvatar extends StatelessWidget {
  final double size;
  final Shape type;
  final void Function()? onTap;

  const ImageAvatar({
    super.key,
    this.size = 80,
    required this.type,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return switch (type) {
      Shape.STORY => _storyAvatar(),
      Shape.ON => _onAvatar(),
      Shape.OFF => _offAvatar(),
      Shape.MYSTORY => _myStoryAvatar(),
    };
  }

  Widget _basicAvatar() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration:
          const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
      child: CircleAvatar(
        radius: size / 2,
        backgroundImage: AssetImage('assets/images/user1.png'),
      ),
    );
  }

  Widget _storyAvatar() {
    return Container(
      height: size + 4,
      width: size + 4,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        // 스토리 영역의 테두리를
        // 그라데이션으로 줄 수 있음.
        gradient: LinearGradient(
          // 시작 방향 지정
          begin: Alignment.bottomLeft,
          // 종료 되는 방향 지정
          end: Alignment.topRight,
          colors: [
            // hex 컬러
            Color(0xfffce80a), // 노랑
            Color(0xfffc3a0a), // 빨강
            Color(0xffc80afc), // 보라
          ],
        ),
      ),
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: _basicAvatar(),
      ),
    );
  }

  Widget _onAvatar() {
    return Container(
      height: size + 4,
      width: size + 4,
      padding: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,
      ),
      child: _basicAvatar(),
    );
  }

  Widget _offAvatar() {
    return Container(
      height: size + 4,
      width: size + 4,
      padding: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: _basicAvatar(),
    );
  }

  Widget _myStoryAvatar() {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          _storyAvatar(),
          Positioned(
            // 위치 변경
            bottom: 0.5, //하단부
            right: 0.5, //우측
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade100,
              ),
              child: Container(
                width: 20,
                height: 20,
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blueAccent,
                ),
                child: const Icon(
                  size: 16,
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
