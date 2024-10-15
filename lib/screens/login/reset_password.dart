// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_age/helpers/constans.dart';
import 'package:new_age/scripts/snack_bar.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  TextEditingController emailTextInputController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailTextInputController.dispose();

    super.dispose();
  }

  Future<void> resetPassword() async {
    final navigator = Navigator.of(context);
    final scaffoldMassager = ScaffoldMessenger.of(context);

    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailTextInputController.text.trim());
    } on FirebaseAuthException catch (e) {
      // ignore: avoid_print
      print(e.code);

      if (e.code == 'user-not-found') {
        SnackBarService.showSnackBar(
          context,
          'This email is not registered!',
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

    const snackBar = SnackBar(
      content: Text('Resetting the password is done. Check your mail'),
      backgroundColor: Colors.green,
    );

    scaffoldMassager.showSnackBar(snackBar);

    navigator.pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromRGBO(238, 239, 241, 1),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 70),
            child: FloatingActionButton(
              onPressed: () {
                Navigator.pop(context);
              },
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: const Icon(
                CupertinoIcons.arrow_left,
                color: Colors.black,
              ),
            ),
          ),
          Form(
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
                          height: 150,
                        ),
                        Center(
                          child: Text(
                            'Восстановление пароля',
                            style: titleStyle,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(
                          height: 150,
                        ),
                        Center(
                          child: Text(
                            'Введите вашу почту для дальнейшего\nвосстановления пароля',
                            style: subtitleStyle,
                            textAlign: TextAlign.center,
                          ),
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
                      ],
                    ),
                    SvgPicture.asset('lib/assets/images/Heavy Waves.svg'),
                    ElevatedButton(
                      onPressed: resetPassword,
                      style: loginButtonStyle,
                      child: SizedBox(
                        height: 53,
                        width: double.infinity,
                        child: Center(
                            child: Text('Отправить еще раз', style: buttonTextStyle)),
                      ),
                    ),
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}
