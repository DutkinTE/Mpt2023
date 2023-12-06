import 'package:flutter/material.dart';
import 'package:mpit2023/widgets/stars.dart';

class HotelCard extends StatefulWidget {
  const HotelCard(
      {super.key,
      required this.title,
      required this.images,
      required this.address,
      required this.rating});

  final String title;
  final List<String> images;
  final String address;
  final int rating;

  @override
  State<HotelCard> createState() => _HotelCardState();
}

class _HotelCardState extends State<HotelCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
          height: 132,
          width: double.infinity,
          decoration: BoxDecoration(
              color: Color.fromRGBO(234, 236, 240, 1),
              borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      widget.images[0],
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    )),
                const SizedBox(
                  width: 16,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Gilroy',
                          color: Colors.black,
                          fontWeight: FontWeight.w800),
                    ),
                    Text(
                      widget.address,
                      style: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'Gilroy',
                          color: Colors.black,
                          fontWeight: FontWeight.w700),
                    ),
                    StarsWidget(rating: widget.rating)
                  ],
                )
              ],
            ),
          )),
    );
  }
}
