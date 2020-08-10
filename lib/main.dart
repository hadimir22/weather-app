import 'package:flutter/material.dart';
import 'package:weatherApp/ui/add_cities.dart';
import 'package:weatherApp/ui/manage_cities.dart';
import './ui//weather.dart';

void main() {
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Weatherman',
    initialRoute: 'home',
    routes: {
      'home': (context) => Weather(),
      '/addCities': (context) => AddCities(),
      '/manageCities': (context) => ManageCities(),
    },
    home: new Weather(),
  ));
}
