import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_age/screens/home_screen.dart';
import 'package:new_age/screens/loader.dart';
import 'package:new_age/screens/login/firebase_stream.dart';
import 'package:new_age/screens/login/login.dart';
import 'package:new_age/screens/login/reset_password.dart';
import 'package:new_age/screens/login/signin.dart';
import 'package:new_age/screens/login/verify_email_screen.dart';
import 'package:new_age/scripts/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/loader': (context) => const LoaderScreen(),
        '/': (context) => const FirebaseStream(),
        '/home': (context) => const HomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignInScreen(),
        '/reset_password': (context) => const ResetPasswordScreen(),
        '/verify_email': (context) => const VerifyEmailScreen(),
      },
      initialRoute: '/loader',
    );
  }
}
