import 'dart:io';

import 'package:challengeone/config/color.dart';
import 'package:challengeone/widgets/button_widget.dart';
import 'package:challengeone/widgets/dialog_widget.dart';
import 'package:challengeone/widgets/textfield_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddStoryPage extends StatefulWidget {
  @override
  State<AddStoryPage> createState() => _AddStoryPageState();
}

class _AddStoryPageState extends State<AddStoryPage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  final TextEditingController _storyCaptionController = TextEditingController();
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
  }

  Future<void> _uploadStory() async {
    if (_imageFile == null) return;

    try {
      final uid = FirebaseAuth.instance.currentUser?.uid ?? 'guest';
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
          return DialogUI(
            title: '스토리 업로드 오류',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('새 스토리'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              CustomTextField(
                backgroundColor: white,
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
              SecondaryButton(
                text: "이미지 선택",
                onTap: _pickImage,
              ),
              const SizedBox(
                height: 16,
              ),
              PrimaryButton(
                text: "스토리 추가",
                onTap: _uploadStory,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
