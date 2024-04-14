import 'dart:convert';
import 'package:download/download.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:flutter/material.dart';

class TestWidget extends StatefulWidget {
  const TestWidget({super.key});

  @override
  State<TestWidget> createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  Future jsonToCsvAndDownloadAction(String jsonString) async {
    // convert from json to csv and download it, without using csv library
    List<Map<String, dynamic>> jsonList =
        jsonDecode(jsonString).cast<Map<String, dynamic>>();

    // Extract the headers from the first object
    List<String> headers = jsonList[0].keys.toList();

    // Create a string to hold the CSV data
    String csvData = "${headers.join(",")}\n";
    // Loop through the objects and add their values to the CSV string
    for (Map<String, dynamic> json in jsonList) {
      List<String> values = [];
      for (String header in headers) {
        if (header == 'tags'){
          
        }
        values.add(json[header].toString());
      }
      csvData += "${values.join(",")}\n";
    }
    // Generate a formatted timestamp for the filename
    final formattedDateTime =
        DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    // Custom filename with date, time, and "custom_name"
    final fileName = 'custom_name_$formattedDateTime.csv';
    // Convert the CSV string to a list of bytes (Uint8List)
    Uint8List csvBytes = Uint8List.fromList(csvData.codeUnits);
    // Convert the Uint8List to a Stream<int>
    Stream<int> csvStream = Stream.fromIterable(csvBytes.map((byte) => byte));
    // Download the CSV file with the custom filename
    await download(csvStream, fileName);
  }

  @override
  Widget build(BuildContext context) {
    String jsonString =
        '[{"name": "BaikalWood EcoLodge&SPA","star_rating": "4.5","tags": ["Бесплатный завтрак","Бесплатный Wi-Fi","Бесплатная парковка","Фитнес-центр","Спа-салон","Бар","Ресторан","Обслуживание в номерах"],"images_url": ["https://lh5.googleusercontent.com/p/AF1QipMmlPyNiXQqe8oIP4ujq08cL-iLaydroK_u2mg7=s287-w287-h192-n-k-no-v1","https://lh5.googleusercontent.com/p/AF1QipOumLwrqtXHrflPggSwBCznZP8Og4ja47B2P8Z_=s287-w287-h192-n-k-no-v1","https://lh5.googleusercontent.com/p/AF1QipM2iGzFBdmPMY5PTuL8aiQjfpsJWbBQbAxQrP9t=s287-w287-h192-n-k-no-v1","https://lh5.googleusercontent.com/p/AF1QipOJB0kIQyzJL8d-9Auds0MEExf50sosaS1PpnGs=s287-w287-h192-n-k-no-v1","https://lh5.googleusercontent.com/p/AF1QipPXyi939CbEftk8WGdJP9CnyeL8hFPV78pXRdYz=s287-w287-h192-n-k-no-v1"]},{"name": "BaikalWood EcoLodge&SPA","star_rating": "4.5","tags": ["Бесплатный завтрак","Бесплатный Wi-Fi","Бесплатная парковка","Фитнес-центр","Спа-салон","Бар","Ресторан","Обслуживание в номерах"],"images_url": ["https://lh5.googleusercontent.com/p/AF1QipMmlPyNiXQqe8oIP4ujq08cL-iLaydroK_u2mg7=s287-w287-h192-n-k-no-v1","https://lh5.googleusercontent.com/p/AF1QipOumLwrqtXHrflPggSwBCznZP8Og4ja47B2P8Z_=s287-w287-h192-n-k-no-v1","https://lh5.googleusercontent.com/p/AF1QipM2iGzFBdmPMY5PTuL8aiQjfpsJWbBQbAxQrP9t=s287-w287-h192-n-k-no-v1","https://lh5.googleusercontent.com/p/AF1QipOJB0kIQyzJL8d-9Auds0MEExf50sosaS1PpnGs=s287-w287-h192-n-k-no-v1","https://lh5.googleusercontent.com/p/AF1QipPXyi939CbEftk8WGdJP9CnyeL8hFPV78pXRdYz=s287-w287-h192-n-k-no-v1"]}]';
    return MaterialApp(
        home: Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          jsonToCsvAndDownloadAction(jsonString);
        },
        backgroundColor: Colors.green,
        splashColor: Colors.greenAccent,
        child: const Icon(
          Icons.download,
          size: 30.0,
        ),
      ),
    ));
    
  }
}
