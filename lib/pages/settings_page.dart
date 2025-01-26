import 'dart:io';

import 'package:challengeone/models/theme_model.dart';
import 'package:challengeone/pages/auth/log_in_page.dart';
import 'package:challengeone/providers/theme_provider.dart';
import 'package:challengeone/widgets/c_button.dart';
import 'package:challengeone/widgets/c_dialog.dart';
import 'package:challengeone/widgets/c_ink_well.dart';
import 'package:challengeone/widgets/c_switch.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final auth = FirebaseAuth.instance;

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  File? _imageFile;

  Future<void> _pickImage() async {
    final isDarkMode = ref.watch(themeProvider);

    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CDialog(
            title: '이미지 선택 오류',
            content: Text(
              '$e',
              style: TextStyle(
                color: ThemeModel.text(isDarkMode),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            buttons: [
              CButton(
                size: CButtonSize.extraLarge,
                label: '확인',
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    if (_imageFile != null) {
      try {
        final storageRef = storage.ref().child(
            'profileImageUrl/${DateTime.now().millisecondsSinceEpoch}.jpg');
        await storageRef.putFile(_imageFile!);
        final imageUrl = await storageRef.getDownloadURL();

        await firestore.collection('user').doc(auth.currentUser?.uid).set({
          'uid': auth.currentUser?.uid,
          'name': auth.currentUser?.displayName,
          'profileImageUrl': imageUrl,
        });
      } catch (e) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return CDialog(
              title: '회원 가입 오류',
              content: Text(
                '$e',
                style: TextStyle(
                  color: ThemeModel.text(isDarkMode),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              buttons: [
                CButton(
                  size: CButtonSize.extraLarge,
                  label: '확인',
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: SafeArea(
            child: Column(
              children: [
                Container(
                  color: ThemeModel.surface(isDarkMode),
                  child: Column(
                    children: [
                      /// 다크 모드
                      CInkWell(
                        onTap: () {
                          ref.read(themeProvider.notifier).toggleTheme();
                        },
                        child: Container(
                          color: ThemeModel.surface(isDarkMode),
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Text(
                                '다크 모드',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: ThemeModel.text(isDarkMode),
                                ),
                              ),
                              const Spacer(),
                              CSwitch(
                                value: isDarkMode,
                                onChanged: (_) {
                                  ref.read(themeProvider.notifier).toggleTheme();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Container(
                  color: ThemeModel.surface(isDarkMode),
                  child: Column(
                    children: [
                      /// 프로필 이미지 변경
                      CInkWell(
                        onTap: _pickImage,
                        child: Container(
                          color: ThemeModel.surface(isDarkMode),
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Text(
                                '프로필 이미지 변경',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: ThemeModel.text(isDarkMode),
                                ),
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                      ),
            
                      /// 로그아웃
                      CInkWell(
                        onTap: () async {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CDialog(
                                title: '로그아웃',
                                content: Text(
                                  '정말 로그아웃할까요?',
                                  style: TextStyle(
                                    color: ThemeModel.text(isDarkMode),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                buttons: [
                                  CButton(
                                    style: CButtonStyle.secondary(isDarkMode),
                                    size: CButtonSize.extraLarge,
                                    label: '취소',
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  CButton(
                                    size: CButtonSize.extraLarge,
                                    label: '로그아웃',
                                    onTap: () async {
                                      await FirebaseAuth.instance.signOut();
            
                                      Navigator.of(context).pushAndRemoveUntil(
                                        CupertinoPageRoute(
                                          builder: (context) => const LogInPage(),
                                        ),
                                        (route) => false,
                                      );
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Container(
                          color: ThemeModel.surface(isDarkMode),
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Text(
                                '로그아웃',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: ThemeModel.text(isDarkMode),
                                ),
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
