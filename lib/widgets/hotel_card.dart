import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mpit2023/helpers/constans.dart';
import 'package:mpit2023/screens/home_screen.dart';
import 'package:mpit2023/widgets/hotel_desc.dart';
import 'package:mpit2023/widgets/stars.dart';

class HotelCard extends StatefulWidget {
  const HotelCard(
      {super.key,
      required this.title,
      required this.images,
      required this.address,
      required this.rating});

  final String title;
  final List<dynamic> images;
  final String address;
  final int rating;

  @override
  State<HotelCard> createState() => _HotelCardState();
}

class _HotelCardState extends State<HotelCard> {
  
  @override
  Widget build(BuildContext context) {
    
    List<dynamic> images = ['https://www.shutterstock.com/ru/image-vector/missing-picture-page-website-design-mobile-1552421075'];
    if (widget.images.isNotEmpty){
      images = widget.images;
    }
    return Container(
        height: 132,
        width: double.infinity,
        decoration: BoxDecoration(
            color: const Color.fromRGBO(234, 236, 240, 1),
            borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    images[0],
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  )),
              const SizedBox(
                width: 16,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 180,
                    child: Text(
                      widget.title,
                      overflow: TextOverflow.fade,
                      maxLines: 2,
                      softWrap: false,
                      style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Gilroy',
                          color: Colors.black,
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                  // Text(
                  //   widget.address,
                  //   style: const TextStyle(
                  //       fontSize: 12,
                  //       fontFamily: 'Gilroy',
                  //       color: Colors.black,
                  //       fontWeight: FontWeight.w700),
                  // ),
                  StarsWidget(rating: widget.rating)
                ],
              )
            ],
          ),
        ));
  }
}
