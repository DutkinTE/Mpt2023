import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

TextStyle titleStyle = const TextStyle(
    color: Colors.black,
    fontSize: 27,
    fontWeight: FontWeight.w600,
    fontFamily: 'Girloy');

TextStyle subtitleStyle = const TextStyle(
    color: Color.fromRGBO(142, 144, 151, 1),
    fontSize: 12,
    fontWeight: FontWeight.w600,
    fontFamily: 'Girloy');

TextStyle buttonTextStyle = const TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    fontFamily: 'Girloy');

TextStyle buttonBlueTextStyle = const TextStyle(
    color: Color.fromRGBO(21, 112, 239, 1),
    fontSize: 12,
    fontWeight: FontWeight.w600,
    fontFamily: 'Girloy');

TextStyle afterFieldTextStyle = const TextStyle(
    color: Colors.black,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    fontFamily: 'Girloy');

TextStyle fieldTextStyle = const TextStyle(
    color: Colors.black,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    fontFamily: 'Girloy');

TextStyle buttonBlackTextStyle = const TextStyle(
    color: Colors.black,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    fontFamily: 'Girloy');

TextStyle underFieldTextStyle = const TextStyle(
    color: Colors.white,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    fontFamily: 'Girloy');

InputDecoration loginFieldDecoration(String image) {
  return InputDecoration(
    prefixIcon: SvgPicture.asset(image, fit: BoxFit.none,),
      contentPadding: const EdgeInsets.only(bottom: 5, top: 5),
      enabledBorder: const OutlineInputBorder(
          borderSide:
              BorderSide(color: Color.fromRGBO(142, 144, 151, 1), width: 0.5),
          borderRadius: BorderRadius.all(Radius.circular(24))),
      border: const OutlineInputBorder(
          borderSide:
              BorderSide(color: Color.fromRGBO(142, 144, 151, 1), width: 0.5),
          borderRadius: BorderRadius.all(Radius.circular(24))));
}

ButtonStyle loginButtonStyle = ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    side: BorderSide.none,
                    borderRadius: BorderRadius.circular(48),
                  ),
                ),
                elevation: MaterialStateProperty.all(0),
                backgroundColor: MaterialStateProperty.all<Color?>(const Color.fromRGBO(21, 112, 239, 1)),
              );

double height = 100;
double height2 = 0;
double height3 = 0;
String currentCity = 'Москва';

Widget splashContent = Container();
List pages = [];
Widget genDesc = Container();
List blackList = [];
List whiteList = [];