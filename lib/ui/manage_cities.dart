import 'package:flutter/material.dart';

class ManageCities extends StatefulWidget {
  @override
  _ManageCitiesState createState() => _ManageCitiesState();
}

class _ManageCitiesState extends State<ManageCities> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Manage cities'),
        backgroundColor: Colors.redAccent,
      ),
    );
  }
}
