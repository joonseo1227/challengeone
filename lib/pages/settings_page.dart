import 'dart:io';

import 'package:challengeone/pages/login_page.dart';
import 'package:challengeone/widgets/button_widget.dart';
import 'package:challengeone/widgets/dialog_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

final auth = FirebaseAuth.instance;

class SettingsPage extends StatefulWidget {
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  File? _imageFile;

  Future<void> _pickImage() async {
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
          return DialogUI(
            title: '이미지 선택 오류',
            content: '$e',
            buttons: [
              DialogButtonData(
                  text: '확인',
                  onTap: () {
                    Navigator.of(context).pop();
                  }),
            ],
            buttonAxis: Axis.horizontal,
          );
        },
      );
    }

    if (_imageFile != null) {
      try {
        final storageRef = storage
            .ref()
            .child('profileImage/${DateTime.now().millisecondsSinceEpoch}.jpg');
        await storageRef.putFile(_imageFile!);
        final imageUrl = await storageRef.getDownloadURL();

        await firestore.collection('user').doc(auth.currentUser?.uid).set({
          'uid': auth.currentUser?.uid,
          'name': auth.currentUser?.displayName,
          'profileImage': imageUrl,
        });
      } catch (e) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return DialogUI(
              title: '회원 가입 오류',
              content: '$e',
              buttons: [
                DialogButtonData(
                    text: '확인',
                    onTap: () {
                      Navigator.of(context).pop();
                    }),
              ],
              buttonAxis: Axis.horizontal,
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SecondaryButton(
                text: "프로필 이미지 변경",
                onTap: _pickImage,
              ),
              const SizedBox(
                height: 16,
              ),
              SecondaryButton(
                text: "로그아웃",
                onTap: () async {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return DialogUI(
                        title: '로그아웃',
                        content: '정말 로그아웃할까요?',
                        buttons: [
                          DialogButtonData(
                              text: '취소',
                              onTap: () {
                                Navigator.of(context).pop();
                              }),
                          DialogButtonData(
                              text: '로그아웃',
                              onTap: () async {
                                await FirebaseAuth.instance.signOut();

                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginPage()),
                                    (route) => false);
                              }),
                        ],
                        buttonAxis: Axis
                            .horizontal, // Axis.horizontal for horizontal arrangement
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
