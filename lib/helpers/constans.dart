import 'package:flutter/material.dart';

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
    color: Color.fromRGBO(142, 144, 151, 1),
    fontSize: 16,
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

InputDecoration loginFieldDecoration(String label) {
  return InputDecoration(
      labelStyle: const TextStyle(
          color: Color.fromRGBO(142, 144, 151, 1),
          fontSize: 12,
          fontWeight: FontWeight.w400,
          fontFamily: 'Girloy'),
      label: Text(label),
      contentPadding: const EdgeInsets.only(bottom: 5, left: 10, top: 5),
      enabledBorder: const OutlineInputBorder(
          borderSide:
              BorderSide(color: Color.fromRGBO(142, 144, 151, 1), width: 0.5),
          borderRadius: BorderRadius.all(Radius.circular(12))),
      border: const OutlineInputBorder(
          borderSide:
              BorderSide(color: Color.fromRGBO(142, 144, 151, 1), width: 0.5),
          borderRadius: BorderRadius.all(Radius.circular(12))));
}

ButtonStyle loginButtonStyle = ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    side: const BorderSide(
                        color: Color.fromRGBO(142, 144, 151, 1), width: 1),
                    borderRadius: BorderRadius.circular(48),
                  ),
                ),
                elevation: MaterialStateProperty.all(0),
                backgroundColor: MaterialStateProperty.all<Color?>(const Color.fromRGBO(238, 239, 241, 1)),
              );
