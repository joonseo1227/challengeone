import 'package:challengeone/config/font.dart';
import 'package:flutter/material.dart';

class ListTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  ListTitle({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Fonts.title, // Assuming Fonts.title is defined elsewhere
          ),
          Text(
            subtitle,
            style:
                Fonts.subtitle, // Assuming Fonts.subtitle is defined elsewhere
          ),
        ],
      ),
    );
  }
}
