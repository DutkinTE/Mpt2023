import 'package:flutter/cupertino.dart';
import 'package:mpit2023/helpers/constans.dart';
import 'package:mpit2023/screens/check_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:mpit2023/screens/login/login.dart';
import 'package:mpit2023/scripts/slider_animation.dart';


class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    // ignore: avoid_print
    print(isEmailVerified);

    if (isEmailVerified) timer?.cancel();
  }

  Future<void> sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() => canResendEmail = false);
      await Future.delayed(const Duration(seconds: 5));

      setState(() => canResendEmail = true);
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? const CheckScreen()
      : Scaffold(
      backgroundColor: const Color.fromRGBO(238, 239, 241, 1),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 80),
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(context, FadeRoute(page: const LoginScreen()));
              },
              backgroundColor: Colors.white,
              elevation: 0,
              child: const Icon(
                CupertinoIcons.arrow_left,
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16, left: 16, bottom: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Column(children: [
          const SizedBox(
                height: 80,
              ),
              Image.asset(
                'lib/assets/images/ver.png',
              ),
              const SizedBox(
                height: 24,
              ),
              Text('Подтверждение', style: titleStyle, textAlign: TextAlign.center,),
              const SizedBox(
                height: 24,
              ),
              Text('Мы отправили письмо с подтверждением на электронную почту', style: subtitleStyle, textAlign: TextAlign.center,),
              
              const SizedBox(
                height: 24,
              ),
              ],),
              
              ElevatedButton(
                onPressed: sendVerificationEmail,
                style: loginButtonStyle,
                child: SizedBox(
                  height: 53,
                  width: double.infinity,
                  child: Center(
                      child: Text('Отправить ещё раз', style: buttonTextStyle)),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
}
