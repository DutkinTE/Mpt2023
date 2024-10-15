import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_age/screens/login/firebase_stream.dart';
import 'package:new_age/scripts/slider_animation.dart';

class Loader2Screen extends StatefulWidget {
  const Loader2Screen({super.key});

  @override
  State<Loader2Screen> createState() => _Loader2ScreenState();
}

class _Loader2ScreenState extends State<Loader2Screen> {
  @override
  void initState() {
    Timer(const Duration(milliseconds: 700), () {
      Navigator.push(context, FadeRoute(page: const FirebaseStream()));
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(21, 112, 239, 1),
      body: Stack(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 96.0),
            child: Align(alignment: Alignment.topCenter, child: Text('Добро пожаловать!',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 27,
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w600))),
          ),
          Align(alignment: Alignment.bottomRight, child: SvgPicture.asset('lib/assets/images/4.svg'))
        ],
      ),
    );
  }
}
