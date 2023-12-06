// ignore_for_file: use_build_context_synchronously

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mpit2023/helpers/constans.dart';
import 'package:mpit2023/screens/home_screen.dart';
import 'package:mpit2023/screens/login/login.dart';
import 'package:mpit2023/screens/login/reset_password.dart';
import 'package:mpit2023/scripts/slider_animation.dart';
import 'package:mpit2023/scripts/snack_bar.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool isHiddenPassword = true;
  TextEditingController emailTextInputController = TextEditingController();
  TextEditingController passwordTextInputController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final user = FirebaseAuth.instance.currentUser;

  @override
  void dispose() {
    emailTextInputController.dispose();
    passwordTextInputController.dispose();

    super.dispose();
  }

  Future<void> login() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailTextInputController.text.trim(),
        password: passwordTextInputController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      // ignore: avoid_print
      print(e.code);

      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        SnackBarService.showSnackBar(
          context,
          'Wrong email or password. Try again',
          true,
        );
        return;
      } else {
        SnackBarService.showSnackBar(
          context,
          'Unknown error! Please try again or contact support.',
          true,
        );
        return;
      }
    }

    Navigator.push(context, FadeRoute(page: const HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromRGBO(238, 239, 241, 1),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.only(right: 16, left: 16, bottom: 50),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const SizedBox(
                      height: 80,
                    ),
                    Image.asset(
                      'lib/assets/images/Frame 1522.png',
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Text(
                      'Добро пожаловать!',
                      style: titleStyle,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Text('Войдите в систему для доступа к своему аккаунту',
                        style: subtitleStyle),
                    const SizedBox(
                      height: 24,
                    ),
                    TextFormField(
                        style: fieldTextStyle,
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        controller: emailTextInputController,
                        validator: (email) =>
                            email != null && !EmailValidator.validate(email)
                                ? 'Enter correct Email'
                                : null,
                        decoration: loginFieldDecoration('Почта')),
                    const SizedBox(
                      height: 24,
                    ),
                    TextFormField(
                        obscureText: isHiddenPassword,
                        style: fieldTextStyle,
                        autocorrect: false,
                        controller: passwordTextInputController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) => value != null && value.length < 6
                            ? 'Minimum 6 characters'
                            : null,
                        decoration: loginFieldDecoration('Пароль')),
                    const SizedBox(
                      height: 24,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            FadeRoute(page: const ResetPasswordScreen()));
                      },
                      child: Text('Забыли пароль?', style: afterFieldTextStyle),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context, FadeRoute(page: const LoginScreen()));
                      },
                      child: Text('Новый пользователь? Зарегистрируйся',
                          style: buttonBlackTextStyle),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: login,
                  style: loginButtonStyle,
                  child: SizedBox(
                    height: 53,
                    width: double.infinity,
                    child:
                        Center(child: Text('Дальше', style: buttonTextStyle)),
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
