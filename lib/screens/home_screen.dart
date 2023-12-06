import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:http/http.dart' as http;
import 'package:mpit2023/screens/login/firebase_stream.dart';
import 'package:mpit2023/scripts/slider_animation.dart';
import 'package:mpit2023/widgets/control_button.dart';
import 'package:mpit2023/widgets/hotel_card.dart';
import 'package:mpit2023/widgets/hotel_desc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late YandexMapController controller;
  GlobalKey mapKey = GlobalKey();
  Widget bottomContent = const Padding(
    padding: EdgeInsets.only(right: 16, left: 16),
    child: Column(
      children: [
        HotelCard(
            title: 'Винтерфелл Курская',
            images: [
              'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/16/1a/ea/54/hotel-presidente-4s.jpg?w=1400&h=-1&s=1',
              'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/13/e9/ce/cf/hotel-presidente-4s-habitacion.jpg?w=1400&h=-1&s=1'
            ],
            address: 'улица Казакова 8, ст. 1',
            rating: 5)
      ],
    ),
  );
  double height = 170;
  Future<void> signOut() async {
    setState(() {
      FirebaseAuth.instance.signOut();
      Navigator.push(context, FadeRoute(page: const FirebaseStream()));
    });
  }

  Future<bool> get locationPermissionNotGranted async =>
      !(await Permission.location.request().isGranted);

  void _showMessage(Text text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: text));
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  void check() {
    setState(() async {
      // var url = Uri.parse('91.107.123.163/hotel-info');
      // var response = await http.post(url);
      // print('##################################################');
      // print('Response status: ${response.statusCode}');
      // print('Response body: ${response.body}');
    });
  }

  @override
  Widget build(BuildContext context) {

    final mapControllerCompleter = Completer<YandexMapController>();
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            YandexMap(
              key: mapKey,
              onMapCreated: (controller) {
                mapControllerCompleter.complete(controller);
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50.0, left: 10),
              child: IconButton(
                  onPressed: signOut,
                  icon: const Icon(
                    CupertinoIcons.arrow_left,
                    color: Colors.black,
                  )),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onVerticalDragUpdate: (details) {
                    setState(() {
                      if (height - details.delta.dy > 170 &&
                          height - details.delta.dy <=
                              MediaQuery.of(context).size.height * 0.4) {
                        height = MediaQuery.of(context).size.height * 0.4;
                      }
                      if (height - details.delta.dy <
                          MediaQuery.of(context).size.height * 0.4) {
                        height = 170;
                      }
                      height = height - details.delta.dy;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24))),
                    width: double.infinity,
                    height: height,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 8,
                        ),
                        Container(
                            height: 3,
                            width: 96,
                            decoration: const BoxDecoration(
                                color: Color.fromRGBO(152, 162, 179, 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)))),
                        const SizedBox(
                          height: 8,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          child: TextFormField(
                            onTap: () {
                              setState(() {
                                height =
                                    MediaQuery.of(context).size.height * 0.8;
                              });
                            },
                            decoration: const InputDecoration(
                                hintText: 'Поиск',
                                hintStyle: TextStyle(
                                    color: Color.fromRGBO(152, 162, 179, 1),
                                    fontFamily: 'Gilroy',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                                contentPadding: EdgeInsets.only(left: 10),
                                prefixIcon: Icon(CupertinoIcons.search),
                                filled: true,
                                fillColor: Color.fromRGBO(234, 236, 240, 1),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(24)))),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(right: 16, left: 16),
                          child: Column(
                            children: [
                              HotelCard(
                                  title: 'Винтерфелл Курская',
                                  images: [
                                    'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/16/1a/ea/54/hotel-presidente-4s.jpg?w=1400&h=-1&s=1',
                                    'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/13/e9/ce/cf/hotel-presidente-4s-habitacion.jpg?w=1400&h=-1&s=1'
                                  ],
                                  address: 'улица Казакова 8, ст. 1',
                                  rating: 5),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )),
            // Center(
            //   child: ControlButton(
            //       onPressed: () async {

            //         if (await locationPermissionNotGranted) {
            //           _showMessage(
            //               const Text('Location permission was NOT granted'));
            //           return;
            //         }
            //         _determinePosition;
            //         print(await controller.getUserCameraPosition());
            //       },
            //       title: 'Get user camera position'),
            // ),
          ],
        ));
  }
}
