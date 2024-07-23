import 'package:challengeone/config/color.dart';
import 'package:challengeone/pages/signup_page.dart';
import 'package:challengeone/widgets/button.dart';
import 'package:challengeone/widgets/dialog.dart';
import 'package:challengeone/widgets/tabbar.dart';
import 'package:challengeone/widgets/textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final auth = FirebaseAuth.instance;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoginButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_updateLoginButtonState);
    _passwordController.addListener(_updateLoginButtonState);
  }

  @override
  void dispose() {
    _emailController.removeListener(_updateLoginButtonState);
    _passwordController.removeListener(_updateLoginButtonState);
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _updateLoginButtonState() {
    setState(() {
      _isLoginButtonEnabled = _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty;
    });
  }

  Future<void> tryLogin(String email, String password) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      Navigator.of(context).pop(); // Close the loading dialog
      if (auth.currentUser?.uid != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MainPage()),
        );
      }
    } catch (e) {
      Navigator.of(context).pop(); // Close the loading dialog
      String errorMessage;
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'invalid-email':
            errorMessage = '잘못된 이메일 형식이에요.';
            break;
          case 'user-not-found':
            errorMessage = '사용자를 찾을 수 없어요.';
            break;
          case 'wrong-password':
            errorMessage = '잘못된 암호예요.';
            break;
          default:
            errorMessage = '로그인 중 오류가 발생했어요. 다시 시도해주세요.';
        }
      } else {
        errorMessage = '로그인 중 오류가 발생했어요. 다시 시도해주세요.';
      }
      // Show error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: const Text(
          "로그인",
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return DialogUI(
                    title: '게스트 모드',
                    content: '로그인 없이 탐색할 수 있어요. 게스트 모드를 시작할까요?',
                    buttons: [
                      DialogButtonData(
                          text: '취소',
                          onTap: () {
                            Navigator.of(context).pop();
                          }),
                      DialogButtonData(
                          text: '시작',
                          onTap: () {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => MainPage()),
                                (route) => false);
                          }),
                    ],
                    buttonAxis: Axis.horizontal,
                  );
                },
              );
            },
            icon: Icon(Icons.close),
            color: grey100,
          ),
        ],
        backgroundColor: white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 48,
              ),
              const Text(
                "친구와 함께\n도전하세요",
                style: TextStyle(
                  color: grey100,
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 48,
              ),
              CustomTextField(
                label: '이메일',
                hint: 'example@example.com',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(
                height: 16,
              ),
              CustomTextField(
                label: '암호',
                obscureText: true,
                controller: _passwordController,
              ),
              const SizedBox(
                height: 16,
              ),
              PrimaryButton(
                text: "로그인",
                isEnabled: _isLoginButtonEnabled,
                onTap: () {
                  if (_isLoginButtonEnabled) {
                    tryLogin(_emailController.text, _passwordController.text);
                  }
                },
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  GhostButton(
                    text: "회원 가입",
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SignupPage()));
                    },
                  ),
                  const Spacer(),
                  GhostButton(
                    text: "암호를 잊으셨나요?",
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return DialogUI(
                            title: '지원되지 않는 기능',
                            content: '아직 지원되지 않는 기능이에요.',
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
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
