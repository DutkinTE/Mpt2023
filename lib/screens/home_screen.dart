import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mpit2023/data/city_list.dart';
import 'package:mpit2023/helpers/constans.dart';
import 'package:mpit2023/screens/login/login.dart';
import 'package:mpit2023/scripts/slider_animation.dart';
import 'package:mpit2023/widgets/hotel_card.dart';
import 'package:mpit2023/widgets/hotel_desc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchTextInputController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  late YandexMapController controller;
  GlobalKey mapKey = GlobalKey();

  Future<void> signOut() async {
    setState(() {
      FirebaseAuth.instance.signOut();
      Navigator.push(context, FadeRoute(page: const LoginScreen()));
    });
  }

  Future<bool> get locationPermissionNotGranted async =>
      !(await Permission.location.request().isGranted);

  List<dynamic> searchList = [];
  Map<String, dynamic> descList = {};

  Future<void> getSearch(String hotelName, String hotelCity) async {
    setState(() async {
      var url = Uri.parse('http://86.110.194.115:8000/search');
      var response = await http.post(
        url,
        body: json.encode(
            <String, String>{"hotel_name": hotelName, "hotel_city": hotelCity}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      setState(() {
        searchList = json.decode(utf8.decode(response.bodyBytes));
        if (searchList.isEmpty) {
          getDesc(hotelName, hotelCity);
        }
      });
    });
  }

  Future<void> getDesc(String hotelName, String hotelCity) async {
    setState(() async {
      var url = Uri.parse('http://86.110.194.115:8000/hotel-info');
      var response = await http.post(
        url,
        body: json.encode(
            <String, String>{"hotel_name": hotelName, "hotel_city": hotelCity}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      setState(() {
        descList = json.decode(utf8.decode(response.bodyBytes));
      });
      setState(() {
        int rating = double.parse(
                descList['star_rating'].toString().replaceAll(',', '.'))
            .round();
        bottomDesc = HotelDesc(
          json: descList,
          title: descList['name'],
          images: descList['images_url'],
          address: descList['address'],
          rating: rating,
          desc: descList['description'],
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    splashContent = Form(
      key: formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 32,
              child: Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 32 - 58,
                    child: TextFormField(
                      controller: searchTextInputController,
                      onTap: () {
                        setState(() {
                          height = MediaQuery.of(context).size.height * 0.8;
                        });
                      },
                      decoration: InputDecoration(
                          hintText: 'Поиск',
                          hintStyle: const TextStyle(
                              color: Color.fromRGBO(152, 162, 179, 1),
                              fontFamily: 'Gilroy',
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                          contentPadding: const EdgeInsets.only(left: 10),
                          prefixIcon: SvgPicture.asset(
                            'lib/assets/images/icon_search.svg',
                            fit: BoxFit.none,
                          ),
                          filled: true,
                          fillColor: const Color.fromRGBO(234, 236, 240, 1),
                          border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(24)))),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        searchList = [
                          {"state": "loading"}
                        ];
                      });

                      getSearch(searchTextInputController.text, currentCity);
                    },
                    child: Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                          color: const Color.fromRGBO(21, 112, 239, 1),
                          borderRadius: BorderRadius.circular(50)),
                      child: SvgPicture.asset(
                        'lib/assets/images/icon_nav.svg',
                        fit: BoxFit.none,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          SizedBox(
            height: height - 83,
            child: ListView.builder(
              padding: const EdgeInsets.only(left: 16, right: 16),
              shrinkWrap: true,
              itemCount: searchList.length,
              itemBuilder: (context, index) {
                if (searchList[0]['state'] == 'loading') {
                  return const Center(child: CircularProgressIndicator());
                }
                int rating = double.parse(searchList[index]['star_rating']
                        .toString()
                        .replaceAll(',', '.'))
                    .round();
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          height3 = MediaQuery.of(context).size.height * 0.8;
                          height = height3;
                          bottomDesc = const Center(
                            child: CircularProgressIndicator(),
                          );
                        });
                        getDesc(
                            searchList[index]['name'].toString(), currentCity);
                      },
                      child: HotelCard(
                          title: searchList[index]['name'].toString(),
                          images: searchList[index]['images_url'],
                          address: 'address',
                          rating: rating),
                    ),
                    const SizedBox(
                      height: 16,
                    )
                  ],
                );
              },
            ),
          )
        ],
      ),
    );

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            YandexMap(
              key: mapKey,
              onMapCreated: (YandexMapController yandexMapController) async {
                controller = yandexMapController;
                controller.moveCamera(CameraUpdate.newCameraPosition(
                    CameraPosition(
                        target: Point(latitude: 55.75, longitude: 37.6),
                        zoom: 10)));
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 60.0, left: 10),
              child: FloatingActionButton(
                  backgroundColor: Colors.white,
                  onPressed: () {
                    setState(() {
                      height3 = 0;
                      genDesc = Container();
                    });
                  },
                  child: SvgPicture.asset('lib/assets/images/icon_arrow.svg')),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 70.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      height2 = MediaQuery.of(context).size.height;
                    });
                  },
                  child: Text(
                    currentCity,
                    style: const TextStyle(
                        fontFamily: 'Gilroy',
                        fontSize: 27,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50.0, right: 10),
              child: Align(
                  alignment: Alignment.topRight,
                  child: FloatingActionButton(
                    onPressed: signOut,
                    backgroundColor: Colors.white,
                    child: SvgPicture.asset('lib/assets/images/icon_user.svg'),
                  )),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onVerticalDragUpdate: (details) {
                    setState(() {
                      if (height - details.delta.dy > 100 &&
                          height - details.delta.dy <=
                              MediaQuery.of(context).size.height * 0.4) {
                        height = MediaQuery.of(context).size.height * 0.4;
                      }
                      if (height - details.delta.dy <
                          MediaQuery.of(context).size.height * 0.4) {
                        height = 100;
                      }
                      height = height - details.delta.dy;
                    });
                  },
                  child: AnimatedContainer(
                      duration: const Duration(milliseconds: 0),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(24),
                              topRight: Radius.circular(24))),
                      width: double.infinity,
                      height: height,
                      child: Column(children: [
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
                        splashContent,
                      ])),
                )),
            Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onVerticalDragUpdate: (details) {
                    setState(() {
                      if (height - details.delta.dy > 100 &&
                          height - details.delta.dy <=
                              MediaQuery.of(context).size.height * 0.4) {
                        height = MediaQuery.of(context).size.height * 0.4;
                      }
                      if (height - details.delta.dy <
                          MediaQuery.of(context).size.height * 0.4) {
                        height = 100;
                      }
                      height = height - details.delta.dy;
                      height3 = height;
                    });
                  },
                  child: AnimatedContainer(
                      duration: const Duration(milliseconds: 0),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(24),
                              topRight: Radius.circular(24))),
                      width: double.infinity,
                      height: height3,
                      child: Column(children: [
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
                        SizedBox(
                            height: (height3 > 19) ? height3 - 19 : 0,
                            child: bottomDesc)
                      ])),
                )),
            Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedContainer(
                    duration: const Duration(milliseconds: 0),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24))),
                    width: double.infinity,
                    height: height2,
                    child: Column(children: [
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
                      SizedBox(
                        height: MediaQuery.of(context).size.height - 19,
                        child: ListView.builder(
                          padding: const EdgeInsets.only(
                              right: 16, left: 16, top: 50),
                          shrinkWrap: true,
                          itemCount: cities.length,
                          itemBuilder: (context, index) {
                            if (currentCity == cities[index]) {
                              return Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        currentCity = cities[index];
                                        controller.moveCamera(
                                            CameraUpdate.newCameraPosition(
                                                CameraPosition(
                                                    target: Point(
                                                        latitude: points[index]
                                                            [0],
                                                        longitude: points[index]
                                                            [1]),
                                                    zoom: 10)));
                                        height2 = 0;
                                      });
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          color: const Color.fromRGBO(
                                              21, 112, 239, 1)),
                                      child: Text(
                                        cities[index],
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Gilroy',
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  )
                                ],
                              );
                            } else {
                              return Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        currentCity = cities[index];
                                        controller.moveCamera(
                                            CameraUpdate.newCameraPosition(
                                                CameraPosition(
                                                    target: Point(
                                                        latitude: points[index]
                                                            [0],
                                                        longitude: points[index]
                                                            [1]),
                                                    zoom: 10)));
                                        height2 = 0;
                                      });
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          color: const Color.fromRGBO(
                                              234, 236, 240, 1)),
                                      child: Text(
                                        cities[index],
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Gilroy',
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  )
                                ],
                              );
                            }
                          },
                        ),
                      )
                    ]))),
          ],
        ));
  }
}

Widget bottomDesc = Container();
