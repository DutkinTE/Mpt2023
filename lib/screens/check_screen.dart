
import 'package:new_age/screens/login/login.dart';
import 'package:new_age/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CheckScreen extends StatelessWidget {
  const CheckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    Widget screen = const LoginScreen();

    (user == null) ? screen = const LoginScreen() : screen = const HomeScreen();
    return screen;
  }
}


