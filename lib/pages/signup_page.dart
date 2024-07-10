import 'package:challengeone/config/color.dart';
import 'package:challengeone/pages/login_page.dart';
import 'package:challengeone/widgets/button.dart';
import 'package:challengeone/widgets/dialog.dart';
import 'package:challengeone/widgets/textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
    _clearErrors(); // Clear error states

    bool isValid = true;

    if (!isEmailValid(_emailController.text)) {
      setState(() {
        _emailError = '유효하지 않은 이메일 형식이에요.';
        _emailController.clear(); // Clear the email field
      });
      isValid = false;
    }

    if (_passwordController.text.length < 6) {
      setState(() {
        _passwordError = '암호는 6글자 이상이어야 해요.';
        _passwordController.clear(); // Clear the password field
      });
      isValid = false;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _confirmPasswordError = '암호가 일치하지 않아요.';
        _confirmPasswordController.clear(); // Clear the confirm password field
      });
      isValid = false;
    }

    if (!isValid) {
      return; // Exit function if there are any errors
    }

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      var result = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await result.user?.updateDisplayName(username);

      Navigator.of(context).pop(); // Dismiss the loading indicator

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return DialogUI(
            title: '회원 가입 완료!',
            content: '회원이 되신 것을 환영해요. 로그인 후 모든 서비스를 이용할 수 있어요.',
            buttons: [
              DialogButtonData(
                text: '확인',
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    (route) => false,
                  );
                },
              ),
            ],
            buttonAxis: Axis.vertical,
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      Navigator.of(context).pop(); // Dismiss the loading indicator

      setState(() {
        switch (e.code) {
          case 'email-already-in-use':
            _emailError = '이미 사용 중인 이메일이에요.';
            _emailController.clear(); // Clear the email field
            break;
          default:
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return DialogUI(
                  title: '회원 가입 오류',
                  content:
                      '오류 코드: ${e.code}\n회원 가입 중 오류가 발생했어요. 나중에 다시 시도해 주세요.',
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
      });
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
        title: Text("회원 가입"),
        backgroundColor: white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
