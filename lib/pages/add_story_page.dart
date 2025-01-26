import 'dart:io';

import 'package:challengeone/models/theme_model.dart';
import 'package:challengeone/providers/theme_provider.dart';
import 'package:challengeone/widgets/c_button.dart';
import 'package:challengeone/widgets/c_dialog.dart';
import 'package:challengeone/widgets/c_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class AddStoryPage extends ConsumerStatefulWidget {
  const AddStoryPage({super.key});

  @override
  ConsumerState<AddStoryPage> createState() => _AddStoryPageState();
}

class _AddStoryPageState extends ConsumerState<AddStoryPage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  final TextEditingController _storyCaptionController = TextEditingController();
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
  }

  Future<void> _uploadStory() async {
    final isDarkMode = ref.watch(themeProvider);

    if (_imageFile == null) return;

    try {
      final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
      final storageRef = storage
          .ref()
          .child('storyImage/${DateTime.now().millisecondsSinceEpoch}.jpg');
      await storageRef.putFile(_imageFile!);
      final imageUrl = await storageRef.getDownloadURL();

      await firestore.collection('story').add({
        'storyCaption': _storyCaptionController.text,
        'storyImageUrl': imageUrl,
        'uid': uid,
      });

      Navigator.of(context).pop();
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CDialog(
            title: '스토리 업로드 오류',
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

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('새 스토리'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              CTextField(
                label: "스토리 캡션",
                controller: _storyCaptionController,
              ),
              const SizedBox(
                height: 16,
              ),
              if (_imageFile != null) Image.file(_imageFile!, height: 200),
              const SizedBox(
                height: 16,
              ),
              CButton(
                style: CButtonStyle.secondary(isDarkMode),
                label: "이미지 선택",
                icon: Icons.photo_outlined,
                width: double.maxFinite,
                onTap: _pickImage,
              ),
              const SizedBox(
                height: 16,
              ),
              CButton(
                label: "스토리 추가",
                icon: Icons.add,
                width: double.maxFinite,
                onTap: _uploadStory,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
