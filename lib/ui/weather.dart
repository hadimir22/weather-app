import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weatherApp/ui/navBar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';

import './util/utils.dart' as utils;

class Weather extends StatefulWidget {
  @override
  _WeatherState createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  List<String> imageList = [
    'images/clear.jpg',
    'images/clouds.jpg',
    'images/freeze.jpg',
    'images/rain.jpg',
    'images/snow.jpg',
    'images/stars.jpg',
    'images/thunder.jpg',
  ];
  var random = new Random();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Center(
              child: Image.asset(imageList[random.nextInt(imageList.length)],
                  width: 490.0, height: 1200.0, fit: BoxFit.fill)),
          NavBar(),
          Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: FullScreenCarousel(),
          )
        ],
      ),
    );
  }
}

class FullScreenCarousel extends StatefulWidget {
  @override
  _FullScreenCarouselState createState() => _FullScreenCarouselState();
}

class _FullScreenCarouselState extends State<FullScreenCarousel> {
  dynamic storedCities;

  void fetchData() async {
    Map data = await getWeather(utils.apiKey, utils.defaultCity);
  }

  Future<Map> getWeather(String apiKey, String city) async {
    String apiURL = "${utils.apiURL}$city&APPID=${utils.apiKey}&units=metric";
    http.Response response = await http.get(apiURL);
    return json.decode(response.body);
  }

  Widget updateTempWidget(String city) {
    return new FutureBuilder(
        future:
            getWeather(utils.apiKey, city == null ? utils.defaultCity : city),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          //this is where we get all of the JSON data, we set up widgets etc.
          if (snapshot.hasData) {
            Map content = snapshot.data;
            return Container(
              child: Column(children: <Widget>[
                Text(
                  content['message'] != null ? content['message'] : '',
                  style: noCityStyle(),
                ),
                Text(
                  content['message'] == null
                      ? content['main']['temp'].toStringAsFixed(1).toString() +
                          '\u2103'
                      : '',
                  style: weatherStyle(),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                  child: Text(
                    content['message'] == null
                        ? " ${content['weather'][0]['description'].toString()}\n"
                        : '',
                    style: description(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
                  child: Text(
                    content['message'] == null
                        ? "${content['main']['temp_min'].toStringAsFixed(1).toString()} / "
                            "${content['main']['temp_max'].toStringAsFixed(1).toString()}"
                        : '',
                    style: description(),
                  ),
                )
              ]),
            );
          } else {
            return Container();
          }
        });
  }

  @override
  void initState() {
    // This is called on init
    super.initState();
    getCities();
  }

  getCities() async {
    var citiesTempHolder = await _loadSavedCities();
    if (citiesTempHolder != null && citiesTempHolder.isNotEmpty) {
      setState(() {
        storedCities = citiesTempHolder;
      });
    } else {}
  }

  Future<List> _loadSavedCities() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getStringList('cities') != null &&
        prefs.getStringList('cities').isNotEmpty) {
      return prefs.getStringList('cities');
    } else {
      print('no city');
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEE, MMM d yyyy').format(now);
    return Builder(
      builder: (context) {
        final double height = MediaQuery.of(context).size.height;
        return storedCities == null
            ? Container(
                color: Colors.black26,
                child: Center(
                    child: CircularProgressIndicator(
                  backgroundColor: Colors.redAccent,
                )),
              )
            : CarouselSlider(
                options: CarouselOptions(
                  height: height,
                  viewportFraction: 1.0,
                  enlargeCenterPage: false,
                  enableInfiniteScroll: false,
                ),
                items: storedCities
                    .map<Widget>(
                      (city) => Container(
                        child: Stack(
                          children: <Widget>[
                            Container(
                              alignment: Alignment.topCenter,
                              margin: const EdgeInsets.fromLTRB(
                                  0.0, 180.0, 0.0, 0.0),
                              child: Column(
                                children: <Widget>[
                                  Text('$city', style: cityStyle()),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      '$formattedDate',
                                      style: dateStyle(),
                                    ),
                                  ),
                                  updateTempWidget(city)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList());
      },
    );
  }
}

//Style
TextStyle cityStyle() {
  return GoogleFonts.josefinSans(
      textStyle: TextStyle(
          color: Colors.white, fontSize: 59.9, fontStyle: FontStyle.normal));
}

TextStyle weatherStyle() {
  return GoogleFonts.josefinSans(
      textStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w400,
          fontSize: 80.0,
          fontStyle: FontStyle.normal));
}

TextStyle description() {
  return GoogleFonts.josefinSans(
      textStyle: TextStyle(
          color: Colors.white70,
          fontSize: 20.0,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.bold));
}

TextStyle dateStyle() {
  return GoogleFonts.josefinSans(
      textStyle: TextStyle(
          color: Colors.white70, fontSize: 20.0, fontStyle: FontStyle.normal));
}

TextStyle noCityStyle() {
  return GoogleFonts.josefinSans(
      textStyle: TextStyle(
          color: Colors.white, fontSize: 50.0, fontWeight: FontWeight.bold));
}
