import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_age/screens/loader2.dart';
import 'package:new_age/scripts/slider_animation.dart';

class LoaderScreen extends StatefulWidget {
  const LoaderScreen({super.key});

  @override
  State<LoaderScreen> createState() => _LoaderScreenState();
}

class _LoaderScreenState extends State<LoaderScreen> {
   @override
  void initState() {
    Timer(const Duration(seconds: 1), () {
      Navigator.push(context, FadeRoute(page: const Loader2Screen()));
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(16, 19, 35, 1),
      body: Stack(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 96.0),
            child: Align(
                alignment: Alignment.topCenter,
                child: Text('Добро пожаловать!',
                    style: TextStyle(
                        color: Color.fromRGBO(152, 162, 179, 1),
                        fontSize: 27,
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w600))),
          ),
          Align(
              alignment: Alignment.bottomRight,
              child: SvgPicture.asset('lib/assets/images/4.svg'))
        ],
      ),
    );
  }
}
