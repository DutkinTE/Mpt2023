// ignore_for_file: use_build_context_synchronously

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_age/helpers/constans.dart';
import 'package:new_age/screens/home_screen.dart';
import 'package:new_age/screens/login/login.dart';
import 'package:new_age/screens/login/reset_password.dart';
import 'package:new_age/scripts/slider_animation.dart';
import 'package:new_age/scripts/snack_bar.dart';

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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 80,
                    ),
                    Center(
                      child: Text(
                        'Вход',
                        style: titleStyle,
                      ),
                    ),
                    const SizedBox(
                      height: 150,
                    ),
                    Center(
                      child: Text('Войдите в аккаунт для дальнейшего\nиспользования сервиса',
                          style: subtitleStyle, textAlign: TextAlign.center,),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 13.0),
                      child: Text(
                        'Почта',
                        style: buttonBlackTextStyle,
                      ),
                    ),
                    const SizedBox(
                      height: 4,
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
                        decoration: loginFieldDecoration('lib/assets/images/icon_mail.svg')),
                    const SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 13.0),
                      child: Text(
                        'Пароль',
                        style: buttonBlackTextStyle,
                      ),
                    ),
                    const SizedBox(
                      height: 4,
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
                        decoration: loginFieldDecoration('lib/assets/images/icon_key.svg')),
                    const SizedBox(
                      height: 24,
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              FadeRoute(page: const ResetPasswordScreen()));
                        },
                        child: Text('Забыли пароль?', style: afterFieldTextStyle),
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context, FadeRoute(page: const LoginScreen()));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Здесь в первый раз? ',
                                style: buttonBlackTextStyle),
                                Text('Зарегистрируйтесь',
                                style: buttonBlueTextStyle),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SvgPicture.asset('lib/assets/images/Heavy Waves.svg'),
                ElevatedButton(
                  onPressed: login,
                  style: loginButtonStyle,
                  child: SizedBox(
                    height: 53,
                    width: double.infinity,
                    child:
                        Center(child: Text('Войти', style: buttonTextStyle)),
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
