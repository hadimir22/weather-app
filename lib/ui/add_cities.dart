import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddCities extends StatefulWidget {
  @override
  _AddCitiesState createState() => _AddCitiesState();
}

class _AddCitiesState extends State<AddCities> {
  final _cityFieldController = new TextEditingController();
  String savedCities = "";
  List<String> selectedCities = List();
  dynamic storedCities;

  _saveCities(String city) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (city != null && city.isNotEmpty) {
      storedCities = await _loadSavedCities();
      print('stored ${storedCities}');
      if (storedCities == null) {
        //first time input
        selectedCities.add(city);
      } else {
        if (!storedCities.contains(city)) {
          selectedCities = [...storedCities, city];
        } else {
          print("city already present");
        }
      }

      prefs.setStringList('cities', selectedCities);
      print(await _loadSavedCities());
    } else {
      print("city is null");
    }
  }

  Future<List> _loadSavedCities() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
//    setState(() {
//      if (prefs.getString('cities') != null &&
//          prefs.getString('cities').isNotEmpty) {
//        _savedCities = prefs.getString('cities');
//      } else {}
//
//    });
    print('okay, ${prefs.getStringList('cities')}');
    if (prefs.getStringList('cities') != null &&
        prefs.getStringList('cities').isNotEmpty) {
      return prefs.getStringList('cities');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text(
          'Add city',
          style: screenName(),
        ),
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
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search, color: Colors.redAccent),
                      onPressed: () => _cityFieldController.clear(),
                    ),
                    hintText: 'Search city',
                    hintStyle: hintStyle(),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 2.0),
                    ),
                  ),
                  controller: _cityFieldController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.search,
                  style: inputStyle(),
                )),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.2, 0.0, 0.2, 10.0),
                child: new ListTile(
                    title: RaisedButton(
                        splashColor: Colors.black26,
                        disabledColor: Colors.grey,
                        elevation: 15.0,
                        onPressed: () {
                          _saveCities(_cityFieldController.text);
//                          Navigator.pop(
//                              context, {'enter': _cityFieldController.text});
                        },
                        color: Colors.redAccent,
                        textColor: Colors.white70,
                        child: new Text(
                          "Add",
                          style: btnText(),
                        ))),
              ),
              Text(_cityFieldController.text)
            ],
          )
        ],
      ),
    );
  }
}

//style

TextStyle inputStyle() {
  return new TextStyle(color: Colors.redAccent, fontStyle: FontStyle.normal);
}

TextStyle screenName() {
  return GoogleFonts.josefinSans(textStyle: TextStyle());
}

TextStyle hintStyle() {
  return GoogleFonts.josefinSans(textStyle: TextStyle());
}

TextStyle btnText() {
  return GoogleFonts.josefinSans(
      textStyle: TextStyle(
          fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white));
}
