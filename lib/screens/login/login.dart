// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_age/helpers/constans.dart';
import 'package:new_age/screens/login/signin.dart';
import 'package:new_age/scripts/slider_animation.dart';
import 'package:new_age/scripts/snack_bar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isHiddenPassword = true;
  TextEditingController emailTextInputController = TextEditingController();
  TextEditingController passwordTextInputController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 80,
                    ),
                    Center(
                      child: Text(
                        'Регистрация',
                        style: titleStyle,
                      ),
                    ),
                    const SizedBox(
                      height: 150,
                    ),
                    Center(
                      child: Text(
                          'Создайте аккаунт для дальнейшего\nиспользования сервиса',
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
                                ? 'Введите правильный Email'
                                : null,
                        decoration: loginFieldDecoration(
                            'lib/assets/images/icon_mail.svg')),
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
                            ? 'Минимум 6 символов'
                            : null,
                        decoration: loginFieldDecoration(
                            'lib/assets/images/icon_key.svg')),
                    const SizedBox(
                      height: 24,
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context, FadeRoute(page: const SignInScreen()));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Уже есть аккаунт? ',
                                style: buttonBlackTextStyle),
                                Text('Войдите',
                                style: buttonBlueTextStyle),
                                
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SvgPicture.asset('lib/assets/images/Heavy Waves.svg'),
                ElevatedButton(
                    onPressed: signUp,
                    style: loginButtonStyle,
                    child: SizedBox(
                      height: 53,
                      width: double.infinity,
                      child: Center(
                          child: Text('Зарегистрироваться',
                              style: buttonTextStyle)),
                    )),
              ]),
        ),
      ),
    );
  }
}
