import 'package:flutter/material.dart';

class HotelDesc extends StatefulWidget {
  const HotelDesc(
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
  State<HotelDesc> createState() => _HotelDescState();
}

class _HotelDescState extends State<HotelDesc> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(0),
      shrinkWrap: true,
      children: [
        Container(
          height: 210,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: widget.images.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    widget.images[index],
                    height: 210,
                    width: 292,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Text(
          widget.title,
          style: const TextStyle(
              fontFamily: 'Gilroy', fontSize: 21, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 16,
        ),
        Row(
          children: [
            const Icon(
              Icons.location_on,
              color: Color.fromRGBO(21, 112, 239, 1),
            ),
            const SizedBox(width: 8,),
            Text(
              widget.address,
              style: const TextStyle(
                  fontFamily: 'Gilroy',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color.fromRGBO(152, 162, 179, 1)),
            )
          ],
        )
      ],
    );
  }
}
