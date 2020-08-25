import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'manage_cities.dart';

class NavBar extends StatefulWidget {
  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20.0, 50.9, 20.5, 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            flex: 1,
            child: IconButton(
              icon: Icon(
                Icons.filter_list,
                size: 30.0,
                color: Colors.white,
              ),
              onPressed: () {
                _goToManageCities();
              },
            ),
          ),
          Flexible(
            flex: 4,
            child: Text(
              'Weatherman',
              style: navText(),
            ),
          ),
          Flexible(
            flex: 1,
            child: IconButton(
              icon: Icon(
                Icons.add_circle,
                color: Colors.white,
                size: 30.0,
              ),
              onPressed: () {
                _goToAddCities();
              },
            ),
          )
        ],
      ),
    );
  }

  //named navigation
  void _goToAddCities() {
    Navigator.pushNamed(context, '/addCities');
  }

  void _goToManageCities() {
    Navigator.pushNamed(context, '/manageCities');
  }
}

TextStyle navText() {
  return GoogleFonts.josefinSans(
      textStyle: TextStyle(
          color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.w600));
}
