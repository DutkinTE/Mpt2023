import 'dart:convert';

import 'package:download/download.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mpit2023/helpers/constans.dart';
import 'package:mpit2023/widgets/stars.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:http/http.dart' as http;

class HotelDesc extends StatefulWidget {
  const HotelDesc(
      {super.key,
      required this.title,
      required this.images,
      required this.address,
      required this.rating,
      required this.desc,
      required this.json});

  final String title;
  final List<dynamic> images;
  final String address;
  final int rating;
  final String desc;
  final dynamic json;

  @override
  State<HotelDesc> createState() => _HotelDescState();
}

class _HotelDescState extends State<HotelDesc> {
  TextEditingController blackListController = TextEditingController();
  TextEditingController whiteListController = TextEditingController();
  Future jsonToCsvAndDownloadAction(Map<String, dynamic> json2) async {
    print('accept3');

    // Extract the headers from the first object
    List<String> headers = json2.keys.toList();

    // Create a string to hold the CSV data
    String csvData = "${headers.join(",")}\n";
    print("csv Data $csvData");
    // Loop through the objects and add their values to the CSV string
    List<String> values = [];
    for (String header in headers) {
      if (header == 'tags') {}
      values.add(json2[header].toString());
    }
    csvData += "${values.join(",")}\n";

    print("csv Data $csvData");
    // Generate a formatted timestamp for the filename
    final formattedDateTime =
        DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    // Custom filename with date, time, and "custom_name"
    final fileName = 'custom_name_$formattedDateTime.csv';
    print(fileName);
    // Convert the CSV string to a list of bytes (Uint8List)
    Uint8List csvBytes = Uint8List.fromList(csvData.codeUnits);
    // Convert the Uint8List to a Stream<int>
    Stream<int> csvStream = Stream.fromIterable(csvBytes.map((byte) => byte));
    // Download the CSV file with the custom filename
    await download(csvStream, fileName);
    print('complete');
  }

  String dropdownValue = "normal";
  PageController pageController = PageController();
  Map<String, dynamic> descList = {};
  Future<void> getGen(
      String hotelName, String hotelCity, String desc, String style) async {
    setState(() async {
      pageController.jumpToPage(2);
      setState(() {
        genDesc = const Center(
          child: CircularProgressIndicator(),
        );
      });

      var url = Uri.parse('http://86.110.194.115:8000/generate-description');
      var response = await http.post(
        url,
        body: json.encode(<String, dynamic>{
          "hotel_name": hotelName,
          "hotel_city": hotelCity,
          "description": desc,
          "must_words": whiteList,
          "stop_words": blackList,
          "style": style,
          "model": "gusev/saiga-mistral-7b",
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      setState(() {
        descList = json.decode(utf8.decode(response.bodyBytes));
      });
      setState(() {
        genDesc = ListView(padding: const EdgeInsets.all(16), children: [
          const Text(
              'Описание было составлено с помощью искусственного интеллекта',
              style: TextStyle(
                  color: Color.fromRGBO(152, 162, 179, 1),
                  fontFamily: 'Gilroy',
                  fontSize: 12,
                  fontWeight: FontWeight.w500)),
          const SizedBox(
            height: 16,
          ),
          Text(descList['generated_description'],
              style: const TextStyle(
                  fontFamily: 'Gilroy',
                  fontSize: 12,
                  fontWeight: FontWeight.w500)),
        ]);
      });
    });
  }

  List<dynamic> revList = [];
  Widget rev = Container();
  Future<void> getRev(String hotelAddress, String hotelName) async {
    setState(() async {
      setState(() {
        rev = const Padding(
          padding: EdgeInsets.only(top: 50.0),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      });
      var url = Uri.parse('http://86.110.194.115:8000/review');
      var response = await http.post(
        url,
        body: json.encode(<String, dynamic>{
          "hotel_name": hotelName,
          "hotel_address": hotelAddress,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      setState(() {
        revList = json.decode(utf8.decode(response.bodyBytes));
        rev = Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 0),
            shrinkWrap: true,
            itemCount: revList.length,
            itemBuilder: (context, index) {
              int rating = double.parse(
                      revList[index]['rating'].toString().replaceAll(',', '.'))
                  .round();
              return Column(
                children: [
                  Container(
                      padding: const EdgeInsets.all(12),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: const Color.fromRGBO(242, 244, 247, 1)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            revList[index]['date'],
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                fontFamily: 'Gilroy'),
                          ),
                          const SizedBox(height: 16,),
                          StarsWidget(rating: rating),
                          const SizedBox(height: 16,),
                          Text(
                            revList[index]['text'],
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                fontFamily: 'Gilroy'),
                          ),
                        ],
                      )),
                  const SizedBox(
                    height: 16,
                  )
                ],
              );
            },
          ),
        );
      });
    });
  }

  int pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    pages = [
      Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              DropdownButtonFormField(
                  value: dropdownValue,
                  onChanged: (value) {
                    setState(() {
                      dropdownValue = value!;
                    });
                  },
                  items: const [
                    DropdownMenuItem(
                        value: "normal", child: Text("Нормальное")),
                    DropdownMenuItem(
                        value: "format", child: Text("Форматированное")),
                    DropdownMenuItem(
                        value: "teenage", child: Text("Молодежное")),
                    DropdownMenuItem(value: "family", child: Text("Семейное")),
                    DropdownMenuItem(
                        value: "voyaging", child: Text("Путешественное")),
                  ]),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                controller: blackListController,
                decoration: InputDecoration(
                    labelText: 'Стоп слова',
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          if (blackListController.text.isNotEmpty) {
                            blackList.add(blackListController.text);
                          }
                          blackListController.text = '';
                        });
                      },
                      child: const Icon(Icons.add),
                    )),
              ),
              SizedBox(
                height: 30,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: blackList.length,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              blackList.removeAt(index);
                            });
                          },
                          child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  border: Border.all(width: 1),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Text(blackList[index])),
                        ),
                        const SizedBox(
                          width: 5,
                        )
                      ],
                    );
                  },
                ),
              ),
              TextFormField(
                controller: whiteListController,
                decoration: InputDecoration(
                    labelText: 'Виш лист',
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          if (whiteListController.text.isNotEmpty) {
                            whiteList.add(whiteListController.text);
                          }
                          whiteListController.text = '';
                        });
                      },
                      child: const Icon(Icons.add),
                    )),
              ),
              SizedBox(
                height: 30,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: whiteList.length,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              whiteList.removeAt(index);
                            });
                          },
                          child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  border: Border.all(width: 1),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Text(whiteList[index])),
                        ),
                        const SizedBox(
                          width: 5,
                        )
                      ],
                    );
                  },
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    getGen(
                        widget.title, currentCity, widget.desc, dropdownValue);
                  },
                  style: loginButtonStyle,
                  child: SizedBox(
                    height: 53,
                    width: double.infinity,
                    child: Center(
                        child: Text('Генерировать', style: buttonTextStyle)),
                  )),
            ],
          )),
      ListView(padding: const EdgeInsets.all(16), children: [
        Text(widget.desc,
            style: const TextStyle(
                fontFamily: 'Gilroy',
                fontSize: 12,
                fontWeight: FontWeight.w500)),
      ]),
      genDesc,
    ];

    List<dynamic> images = [
      'https://www.shutterstock.com/ru/image-vector/missing-picture-page-website-design-mobile-1552421075'
    ];
    if (widget.images.isNotEmpty) {
      images = widget.images;
    }
    return ListView(
      padding: const EdgeInsets.only(top: 16, bottom: 300),
      shrinkWrap: true,
      children: [
        SizedBox(
          height: 210,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: images.length,
            itemBuilder: (context, index) {
              if (index != images.length - 1) {
                return Padding(
                  padding: const EdgeInsets.only(right: 0.0, left: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      images[index],
                      height: 210,
                      width: 292,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.only(right: 16.0, left: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      images[index],
                      height: 210,
                      width: 292,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }
            },
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        pageIndex = 0;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color.fromRGBO(234, 236, 240, 1)),
                          color: (pageIndex == 0)
                              ? const Color.fromRGBO(21, 112, 239, 1)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(24)),
                      child: Padding(
                          padding: const EdgeInsets.only(
                              top: 8, bottom: 8, left: 16, right: 16),
                          child: Text('Обзор',
                              style: TextStyle(
                                  color: (pageIndex == 0)
                                      ? Colors.white
                                      : const Color.fromRGBO(152, 162, 179, 1),
                                  fontFamily: 'Gilroy',
                                  fontWeight: FontWeight.w600))),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        pageIndex = 1;
                        getRev(widget.title, widget.address);
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: (pageIndex == 1)
                              ? const Color.fromRGBO(21, 112, 239, 1)
                              : Colors.white,
                          border: Border.all(
                              color: const Color.fromRGBO(234, 236, 240, 1)),
                          borderRadius: BorderRadius.circular(24)),
                      child: Padding(
                          padding: const EdgeInsets.only(
                              top: 8, bottom: 8, left: 16, right: 16),
                          child: Text('Отзывы',
                              style: TextStyle(
                                  color: (pageIndex == 1)
                                      ? Colors.white
                                      : const Color.fromRGBO(152, 162, 179, 1),
                                  fontFamily: 'Gilroy',
                                  fontWeight: FontWeight.w600))),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  GestureDetector(
                    onTap: () {
                      jsonToCsvAndDownloadAction(widget.json);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              color: const Color.fromRGBO(234, 236, 240, 1)),
                          borderRadius: BorderRadius.circular(24)),
                      child: const Padding(
                          padding: EdgeInsets.only(
                              top: 8, bottom: 8, left: 16, right: 16),
                          child: Text('CSV файл',
                              style: TextStyle(
                                  color: Color.fromRGBO(152, 162, 179, 1),
                                  fontFamily: 'Gilroy',
                                  fontWeight: FontWeight.w600))),
                    ),
                  ),
                ],
              ),
              (pageIndex == 0)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          widget.title,
                          style: const TextStyle(
                              fontFamily: 'Gilroy',
                              fontSize: 21,
                              fontWeight: FontWeight.w600),
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
                            const SizedBox(
                              width: 8,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 64,
                              child: Text(
                                widget.address,
                                maxLines: 3,
                                style: const TextStyle(
                                    fontFamily: 'Gilroy',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromRGBO(152, 162, 179, 1)),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        const Text(
                          'Описание',
                          style: TextStyle(
                              fontFamily: 'Gilroy',
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        SizedBox(
                          height: 350,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    width: 1,
                                    color: const Color.fromRGBO(
                                        234, 236, 240, 1))),
                            child: PageView.builder(
                              controller: pageController,
                              itemCount: 3,
                              itemBuilder: (_, index) {
                                return pages[index];
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Center(
                          child: SmoothPageIndicator(
                            controller: pageController, // PageController
                            count: 3,
                            effect: const ExpandingDotsEffect(
                                dotHeight: 6,
                                dotWidth: 6,
                                radius: 13,
                                dotColor: Color.fromRGBO(152, 162, 179, 1),
                                activeDotColor: Color.fromRGBO(
                                    21, 112, 239, 1)), // your preferred effect
                          ),
                        )
                      ],
                    )
                  : rev
            ],
          ),
        )
      ],
    );
  }
}
