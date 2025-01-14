import 'dart:io';

import 'package:challengeone/config/color.dart';
import 'package:challengeone/pages/login_page.dart';
import 'package:challengeone/widgets/button_widget.dart';
import 'package:challengeone/widgets/dialog_widget.dart';
import 'package:challengeone/widgets/textfield_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

final auth = FirebaseAuth.instance;

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
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

      UserCredential result = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
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
          return DialogUI(
            title: '회원 가입 완료!',
            content: '회원 가입이 완료되었습니다. 로그인 화면으로 이동합니다.',
            buttons: [
              DialogButtonData(
                text: '확인',
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const LoginPage()),
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
          return DialogUI(
            title: '오류',
            content: '회원 가입 중 오류가 발생했습니다: $e',
            buttons: [
              DialogButtonData(
                text: '확인',
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
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: const Text("회원 가입"),
        backgroundColor: white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SecondaryButton(
                text: "프로필 이미지 추가",
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
              CustomTextField(
                label: '이름',
                hint: '홍길동',
                controller: _usernameController,
                errorText: _usernameError,
              ),
              const SizedBox(
                height: 16,
              ),
              CustomTextField(
                label: '이메일',
                hint: 'example@example.com',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                errorText: _emailError,
              ),
              const SizedBox(
                height: 16,
              ),
              CustomTextField(
                label: '암호',
                obscureText: true,
                controller: _passwordController,
                errorText: _passwordError,
              ),
              const SizedBox(
                height: 16,
              ),
              CustomTextField(
                label: '암호 재입력',
                obscureText: true,
                controller: _confirmPasswordController,
                errorText: _confirmPasswordError,
              ),
              const SizedBox(
                height: 16,
              ),
              PrimaryButton(
                text: "계속",
                isEnabled: _isSignUpButtonEnabled,
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
