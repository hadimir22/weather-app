import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ManageCities extends StatefulWidget {
  @override
  _ManageCitiesState createState() => _ManageCitiesState();
}

class _ManageCitiesState extends State<ManageCities> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text(
          'Manage cities',
          style: screenName(),
        ),
        backgroundColor: Colors.redAccent,
      ),
    );
  }
}

TextStyle screenName() {
  return GoogleFonts.josefinSans(textStyle: TextStyle());
}
