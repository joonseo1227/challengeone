import 'package:challengeone/models/theme_model.dart';
import 'package:challengeone/pages/auth/create_account_page.dart';
import 'package:challengeone/providers/theme_provider.dart';
import 'package:challengeone/widgets/c_button.dart';
import 'package:challengeone/widgets/c_dialog.dart';
import 'package:challengeone/pages/main/main_page.dart';
import 'package:challengeone/widgets/c_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final auth = FirebaseAuth.instance;
final firestore = FirebaseFirestore.instance;

class LogInPage extends ConsumerStatefulWidget {
  const LogInPage({super.key});

  @override
  ConsumerState<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends ConsumerState<LogInPage> {
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
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      Navigator.of(context).pop();

      User? user = userCredential.user;

      if (user != null) {
        Navigator.of(context).pushReplacement(
          CupertinoPageRoute(
            builder: (context) => MainPage(),
          ),
        );
      }
    } catch (e) {
      Navigator.of(context).pop();
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "로그인",
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 32,
              ),
              Text(
                "친구와 함께\n도전하세요",
                style: TextStyle(
                  color: ThemeModel.text(isDarkMode),
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 48,
              ),
              CTextField(
                label: '이메일',
                hint: 'example@example.com',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(
                height: 16,
              ),
              CTextField(
                label: '암호',
                obscureText: true,
                controller: _passwordController,
              ),
              const SizedBox(
                height: 16,
              ),
              CButton(
                label: "로그인",
                icon: Icons.navigate_next,
                width: double.maxFinite,
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
                  CButton(
                    style: CButtonStyle.ghost(isDarkMode),
                    label: "회원 가입",
                    onTap: () {
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (context) => const CreateAccountPage(),
                        ),
                      );
                    },
                  ),
                  const Spacer(),
                  CButton(
                    style: CButtonStyle.ghost(isDarkMode),
                    label: "암호를 잊으셨나요?",
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CDialog(
                            title: '지원되지 않는 기능',
                            content: Text(
                              '아직 지원되지 않는 기능이에요.',
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
