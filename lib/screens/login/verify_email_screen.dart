import 'package:flutter/cupertino.dart';
import 'package:new_age/helpers/constans.dart';
import 'package:new_age/screens/check_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:new_age/screens/login/login.dart';
import 'package:new_age/scripts/slider_animation.dart';


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
            padding: const EdgeInsets.only(left: 8.0, top: 80),
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(context, FadeRoute(page: const LoginScreen()));
              },
              backgroundColor: Colors.transparent,
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
                height: 150,
              ),
              Text('Подтверждение', style: titleStyle, textAlign: TextAlign.center,),
              const SizedBox(
                          height: 150,
                        ),
              Text('Мы отправили письмо с подтверждением\nна электронную почту', style: subtitleStyle, textAlign: TextAlign.center,),
              
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
