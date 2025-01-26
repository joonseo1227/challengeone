import 'package:challengeone/config/color.dart';
import 'package:challengeone/pages/add_story_page.dart';
import 'package:challengeone/providers/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/theme_model.dart';

enum Shape { STORY, MYSTORY }

class ImageAvatar extends ConsumerStatefulWidget {
  final double size;
  final Shape type;
  final void Function()? onTap;
  final String? imageUrl;

  const ImageAvatar({
    super.key,
    this.size = 80,
    required this.type,
    this.onTap,
    this.imageUrl,
  });

  @override
  ConsumerState<ImageAvatar> createState() => _ImageAvatarState();
}

class _ImageAvatarState extends ConsumerState<ImageAvatar> {
  @override
  Widget build(BuildContext context) {
    switch (widget.type) {
      case Shape.STORY:
        return _storyAvatar(context);
      case Shape.MYSTORY:
        return _myStoryAvatar(context);
    }
  }

  // 기본 아바타 위젯
  Widget _basicAvatar() {
    final isDarkMode = ref.watch(themeProvider);

    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: ThemeModel.background(isDarkMode),
        shape: BoxShape.circle,
      ),
      child: CircleAvatar(
        radius: widget.size / 2,
        backgroundImage: NetworkImage(widget.imageUrl!),
      ),
    );
  }

  // 스토리 아바타 위젯
  Widget _storyAvatar(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);

    return Container(
      height: widget.size + 3,
      width: widget.size + 3,
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
        ),
        child: _basicAvatar(),
      ),
    );
  }

  // 내 스토리 아바타 위젯
  Widget _myStoryAvatar(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);

    return GestureDetector(
      onTap: widget.onTap,
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
                  CupertinoPageRoute(
                    builder: (context) => const AddStoryPage(),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Container(
                  width: 20,
                  height: 20,
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: blue60,
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
