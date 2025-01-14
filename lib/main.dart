import 'package:challengeone/config/color.dart';
import 'package:challengeone/pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Pretendard",
        scaffoldBackgroundColor: grey10,
        appBarTheme: const AppBarTheme(
          scrolledUnderElevation: 0,
          backgroundColor: grey10,
          toolbarHeight: 80,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: grey100,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: blue50,
          selectionHandleColor: blue50,
          selectionColor: blue30,
        ),
        listTileTheme: const ListTileThemeData(
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: grey100,
          ),
          subtitleTextStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: grey60,
          ),
          tileColor: white,
          contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
        ),
        dividerTheme: const DividerThemeData(
          color: grey20,
          indent: 16,
          endIndent: 16,
          space: 0,
          thickness: 1,
        ),
        tabBarTheme: const TabBarTheme(
          overlayColor: WidgetStatePropertyAll(
            grey20,
          ),
          indicatorColor: grey100,
          dividerColor: grey20,
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(
              width: 2,
            ),
          ),
          unselectedLabelStyle: TextStyle(
            color: grey50,
            fontWeight: FontWeight.w600,
          ),
          labelStyle: TextStyle(
            color: grey100,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: grey10,
          elevation: 0,
          selectedItemColor: grey100,
          unselectedItemColor: grey50,
          selectedLabelStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: white,
        ),
      ),
      home: const CupertinoTheme(
        data: CupertinoThemeData(
          primaryColor: blue50,
        ),
        child: LoginPage(),
      ),
    ),
  );
}
