import 'package:flutter/material.dart';

class StarsWidget extends StatefulWidget {
  const StarsWidget({super.key, required this.rating});

  final int rating;

  @override
  State<StarsWidget> createState() => _StarsWidgetState();
}

class _StarsWidgetState extends State<StarsWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.rating == 1) {
      return const Row(
        children: [
          Icon(Icons.star, color: Color.fromRGBO(21, 112, 239, 1),),
          Icon(Icons.star_border, color: Color.fromRGBO(21, 112, 239, 1),),
          Icon(Icons.star_border, color: Color.fromRGBO(21, 112, 239, 1),),
          Icon(Icons.star_border, color: Color.fromRGBO(21, 112, 239, 1),),
          Icon(Icons.star_border, color: Color.fromRGBO(21, 112, 239, 1),),
        ],
      );
    }
    if (widget.rating == 2) {
      return const Row(
        children: [
          Icon(Icons.star, color: Color.fromRGBO(21, 112, 239, 1),),
          Icon(Icons.star, color: Color.fromRGBO(21, 112, 239, 1),),
          Icon(Icons.star_border, color: Color.fromRGBO(21, 112, 239, 1),),
          Icon(Icons.star_border, color: Color.fromRGBO(21, 112, 239, 1),),
          Icon(Icons.star_border, color: Color.fromRGBO(21, 112, 239, 1),),
        ],
      );
    }
    if (widget.rating == 3) {
      return const Row(
        children: [
          Icon(Icons.star, color: Color.fromRGBO(21, 112, 239, 1),),
          Icon(Icons.star, color: Color.fromRGBO(21, 112, 239, 1),),
          Icon(Icons.star, color: Color.fromRGBO(21, 112, 239, 1),),
          Icon(Icons.star_border, color: Color.fromRGBO(21, 112, 239, 1),),
          Icon(Icons.star_border, color: Color.fromRGBO(21, 112, 239, 1),),
        ],
      );
    }
    if (widget.rating == 4) {
      return const Row(
        children: [
          Icon(Icons.star, color: Color.fromRGBO(21, 112, 239, 1),),
          Icon(Icons.star, color: Color.fromRGBO(21, 112, 239, 1),),
          Icon(Icons.star, color: Color.fromRGBO(21, 112, 239, 1),),
          Icon(Icons.star, color: Color.fromRGBO(21, 112, 239, 1),),
          Icon(Icons.star_border, color: Color.fromRGBO(21, 112, 239, 1),),
        ],
      );
    } else {
      return const Row(
        children: [
          Icon(Icons.star, color: Color.fromRGBO(21, 112, 239, 1),),
          Icon(Icons.star, color: Color.fromRGBO(21, 112, 239, 1),),
          Icon(Icons.star, color: Color.fromRGBO(21, 112, 239, 1),),
          Icon(Icons.star, color: Color.fromRGBO(21, 112, 239, 1),),
          Icon(Icons.star, color: Color.fromRGBO(21, 112, 239, 1),),
        ],
      );
    }
  }
}
