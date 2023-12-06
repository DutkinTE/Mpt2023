// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mpit2023/helpers/constans.dart';
import 'package:mpit2023/screens/login/signin.dart';
import 'package:mpit2023/scripts/slider_animation.dart';
import 'package:mpit2023/scripts/snack_bar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isHiddenPassword = true;
  TextEditingController loginTextInputController = TextEditingController();
  TextEditingController emailTextInputController = TextEditingController();
  TextEditingController passwordTextInputController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    loginTextInputController.dispose();
    emailTextInputController.dispose();
    passwordTextInputController.dispose();

    super.dispose();
  }

  void togglePasswordView() {
    setState(() {
      isHiddenPassword = !isHiddenPassword;
    });
  }

  Future<void> signUp() async {
    final navigator = Navigator.of(context);

    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailTextInputController.text.trim(),
        password: passwordTextInputController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      // ignore: avoid_print
      print(e.code);

      if (e.code == 'email-already-in-use') {
        SnackBarService.showSnackBar(
          context,
          'This Email is already in use, please try again using another Email',
          true,
        );
        return;
      } else {
        SnackBarService.showSnackBar(
          context,
          'Unknown error! Please try again or contact support.',
          true,
        );
      }
    }

    PostDetailsToFirestore();

    navigator.pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  }

  // ignore: non_constant_identifier_names
  PostDetailsToFirestore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;

    await firebaseFirestore
        .collection('users')
        .doc(user?.uid)
        .set({'public': false});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromRGBO(238, 239, 241, 1),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.only(right: 16.0, left: 16, bottom: 50),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  
                  children: [
                    const SizedBox(
                      height: 80,
                    ),
                    Image.asset(
                      'lib/assets/images/Frame 152.png',
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
                    Text('Создайте вашу учетную запись', style: subtitleStyle),
                    const SizedBox(
                      height: 24,
                    ),
                    TextFormField(
                        style: fieldTextStyle,
                        keyboardType: TextInputType.name,
                        autocorrect: false,
                        controller: loginTextInputController,
                        validator: (email) =>
                            email == null ? 'Введите Логин' : null,
                        decoration: loginFieldDecoration('Логин')),
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
                                ? 'Введите правильный Email'
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
                            ? 'Минимум 6 символов'
                            : null,
                        decoration: loginFieldDecoration('Пароль')),
                    const SizedBox(
                      height: 24,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context, FadeRoute(page: const SignInScreen()));
                      },
                      child: Text('Есть существующий аккаунт? Войдите',
                          style: buttonBlackTextStyle),
                    ),
                  ],
                ),
                ElevatedButton(
                    onPressed: signUp,
                    style: loginButtonStyle,
                    child: SizedBox(
                      height: 53,
                      width: double.infinity,
                      child:
                          Center(child: Text('Дальше', style: buttonTextStyle)),
                    )),
              ]),
        ),
      ),
    );
  }
}
