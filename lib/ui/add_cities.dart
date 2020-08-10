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
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0.2, 10.0, 0.2, 10.0),
                child: new ListTile(
                    title: new TextField(
                      cursorColor: Colors.redAccent,
                      decoration: new InputDecoration(
                        suffixIcon: IconButton(icon: Icon(Icons.search, color: Colors.redAccent), onPressed: () => _cityFieldController.clear(), ),
                        hintText: 'search city',
                          border: OutlineInputBorder(),
                          focusedBorder:OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey, width: 2.0),
                    ),
                      ),
                      controller: _cityFieldController,
                      keyboardType: TextInputType.text,
                      style: inputStyle(),
                    )),
              ),
//              Padding(
//                padding: const EdgeInsets.fromLTRB(0.2, 10.0, 0.2, 10.0),
//                child: new ListTile(
//                    title: new FlatButton(
//                        onPressed: () {
//                          _saveCities(_cityFieldController.text);
//                          Navigator.pop(
//                              context, {'enter': _cityFieldController.text});
//                        },
//                        color: Colors.redAccent,
//                        textColor: Colors.white70,
//                        child: new Text("Add"))),
//              )
            ],
          )
        ],
      ),
    );
  }
}


//style

TextStyle inputStyle() {
  return new TextStyle(
      color: Colors.redAccent,
      fontStyle: FontStyle.normal);
}
