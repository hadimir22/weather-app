import 'package:flutter/material.dart';
import 'package:weatherApp/ui/add_cities.dart';
import './ui//weather.dart';

void main() {
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Weatherman',
    initialRoute: 'home',
    routes: {
      'home': (context) => Weather(),
      '/addCities': (context) => AddCities(),
    },

    home: new Weather(),
  ));
}
