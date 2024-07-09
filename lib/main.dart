import 'package:challengeone/pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MaterialApp(
      theme: ThemeData(
        fontFamily: "Pretendard",
        scaffoldBackgroundColor: Colors.grey.shade100,
        appBarTheme: AppBarTheme(
          scrolledUnderElevation: 0,
          backgroundColor: Colors.grey.shade100,
          toolbarHeight: 80,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: Colors.black87,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Colors.black87,
          selectionHandleColor: Colors.black87,
          selectionColor: Colors.black12,
        ),
        listTileTheme: const ListTileThemeData(
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          subtitleTextStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.black54,
          ),
          tileColor: Colors.white,
          contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
        ),
        dividerTheme: DividerThemeData(
          color: Colors.grey.shade300,
          indent: 16,
          endIndent: 16,
          space: 0,
          thickness: 1,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.grey.shade100,
          elevation: 0,
          selectedItemColor: Colors.black87,
          unselectedItemColor: Colors.black38,
          selectedLabelStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: Colors.white,
        ),
      ),
      home: LoginPage(),
    ),
  );
}
