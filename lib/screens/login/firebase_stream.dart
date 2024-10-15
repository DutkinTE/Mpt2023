import 'package:new_age/screens/check_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_age/screens/login/verify_email_screen.dart';


class FirebaseStream extends StatelessWidget {
  const FirebaseStream({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(child: Text('Something went wrong'),),
          );
        } else if (snapshot.hasData) {
          if (!snapshot.data!.emailVerified) {
            return const VerifyEmailScreen();
          }
          return const CheckScreen();
        } else {
          return const CheckScreen();
        }
      },
    );
  }
}