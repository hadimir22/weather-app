import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AddCities extends StatelessWidget {
  final _cityFieldController = new TextEditingController();

  _saveCities(String city) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('cities', city);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
          title: new Text('Add city'),
          backgroundColor: Colors.redAccent,
      ),
      backgroundColor: Colors.white30,
      body: Stack(
        children: <Widget>[
          ListView(
            children: <Widget>[
              new ListTile(
                  title: new TextField(
                    decoration: new InputDecoration(hintText: 'Enter City'),
                    controller: _cityFieldController,
                    keyboardType: TextInputType.text,
                  )),
              new ListTile(
                  title: new FlatButton(
                      onPressed: () {
                        _saveCities(_cityFieldController.text);
                        Navigator.pop(
                            context, {'enter': _cityFieldController.text});
                      },
                      color: Colors.redAccent,
                      textColor: Colors.white70,
                      child: new Text("Add")))
            ],
          )
        ],
      ),
    );
  }
}
