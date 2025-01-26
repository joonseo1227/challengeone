import 'dart:io';

import 'package:challengeone/models/theme_model.dart';
import 'package:challengeone/pages/auth/log_in_page.dart';
import 'package:challengeone/providers/theme_provider.dart';
import 'package:challengeone/widgets/c_button.dart';
import 'package:challengeone/widgets/c_dialog.dart';
import 'package:challengeone/widgets/c_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final auth = FirebaseAuth.instance;

class CreateAccountPage extends ConsumerStatefulWidget {
  const CreateAccountPage({super.key});

  @override
  ConsumerState<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends ConsumerState<CreateAccountPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isSignUpButtonEnabled = false;
  String? _usernameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

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
  }

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(_updateSignUpButtonState);
    _emailController.addListener(_updateSignUpButtonState);
    _passwordController.addListener(_updateSignUpButtonState);
    _confirmPasswordController.addListener(_updateSignUpButtonState);
  }

  @override
  void dispose() {
    _usernameController.removeListener(_updateSignUpButtonState);
    _emailController.removeListener(_updateSignUpButtonState);
    _passwordController.removeListener(_updateSignUpButtonState);
    _confirmPasswordController.removeListener(_updateSignUpButtonState);
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _updateSignUpButtonState() {
    setState(() {
      _isSignUpButtonEnabled = _usernameController.text.isNotEmpty &&
          _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _confirmPasswordController.text.isNotEmpty;
    });
  }

  void _clearErrors() {
    setState(() {
      _usernameError = null;
      _emailError = null;
      _passwordError = null;
      _confirmPasswordError = null;
    });
  }

  Future<void> trySignUp(String username, String email, String password) async {
    _clearErrors();

    final isDarkMode = ref.watch(themeProvider);

    bool isValid = true;

    if (!isEmailValid(_emailController.text)) {
      setState(() {
        _emailError = '유효하지 않은 이메일 형식이에요.';
      });
      isValid = false;
    }

    if (_passwordController.text.length < 6) {
      setState(() {
        _passwordError = '암호는 6글자 이상이어야 해요.';
      });
      isValid = false;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _confirmPasswordError = '암호가 일치하지 않아요.';
      });
      isValid = false;
    }

    if (!isValid) return;

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(child: CircularProgressIndicator());
        },
      );

      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('회원 정보 로드 실패');
      }

      await currentUser.updateDisplayName(username);

      String? imageUrl;
      if (_imageFile != null) {
        final storageRef = storage.ref().child(
            'profileImageUrl/${DateTime.now().millisecondsSinceEpoch}.jpg');
        await storageRef.putFile(_imageFile!);
        imageUrl = await storageRef.getDownloadURL();
      }

      await firestore.collection('user').doc(currentUser.uid).set({
        'uid': currentUser.uid,
        'name': username,
        'profileImageUrl': imageUrl,
      });

      Navigator.of(context).pop(); // 로딩 화면 닫기

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CDialog(
            title: '회원 가입 완료!',
            content: Text(
              '회원 가입이 완료되었습니다. 로그인 화면으로 이동합니다.',
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
    } on FirebaseAuthException catch (e) {
      Navigator.of(context).pop(); // 로딩 화면 닫기
      setState(() {
        if (e.code == 'email-already-in-use') {
          _emailError = '이미 사용 중인 이메일이에요.';
        }
      });
    } catch (e) {
      Navigator.of(context).pop(); // 로딩 화면 닫기
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CDialog(
            title: '오류',
            content: Text(
              '회원 가입 중 오류가 발생했습니다: $e',
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

  bool isEmailValid(String email) {
    // Simple email validation check
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("회원 가입"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CButton(
                style: CButtonStyle.tertiary(isDarkMode),
                label: "프로필 이미지 추가",
                icon: Icons.add,
                width: double.maxFinite,
                onTap: _pickImage,
              ),
              if (_imageFile != null)
                Image.file(
                  _imageFile!,
                  height: 200,
                ),
              const SizedBox(
                height: 16,
              ),
              CTextField(
                label: '이름',
                hint: '홍길동',
                controller: _usernameController,
                errorText: _usernameError,
              ),
              const SizedBox(
                height: 16,
              ),
              CTextField(
                label: '이메일',
                hint: 'example@example.com',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                errorText: _emailError,
              ),
              const SizedBox(
                height: 16,
              ),
              CTextField(
                label: '암호',
                obscureText: true,
                controller: _passwordController,
                errorText: _passwordError,
              ),
              const SizedBox(
                height: 16,
              ),
              CTextField(
                label: '암호 재입력',
                obscureText: true,
                controller: _confirmPasswordController,
                errorText: _confirmPasswordError,
              ),
              const SizedBox(
                height: 16,
              ),
              CButton(
                label: "계속",
                icon: Icons.navigate_next,
                width: double.maxFinite,
                onTap: () {
                  if (_isSignUpButtonEnabled) {
                    trySignUp(
                      _usernameController.text,
                      _emailController.text,
                      _passwordController.text,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
