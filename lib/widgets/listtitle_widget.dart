import 'package:challengeone/models/theme_model.dart';
import 'package:challengeone/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ListTitle extends ConsumerStatefulWidget {
  final String title;
  final String subtitle;

  ListTitle({
    required this.title,
    required this.subtitle,
  });

  @override
  ConsumerState<ListTitle> createState() => _ListTitleState();
}

class _ListTitleState extends ConsumerState<ListTitle> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: TextStyle(
              color: ThemeModel.text(isDarkMode),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            widget.subtitle,
            style: TextStyle(
              color: ThemeModel.sub4(isDarkMode),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
