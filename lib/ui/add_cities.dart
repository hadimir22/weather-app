import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddCities extends StatefulWidget {
  @override
  _AddCitiesState createState() => _AddCitiesState();
}

class _AddCitiesState extends State<AddCities> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _cityFieldController = new TextEditingController();
  String savedCities = "";
  List<String> selectedCities = List();
  dynamic storedCities;

  _saveCities(String city) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (city != null && city.isNotEmpty) {
      storedCities = await _loadSavedCities();
      if (storedCities == null) {
        //first time input
        selectedCities.add(city);
        prefs.setStringList('cities', selectedCities);
      } else {
        if (!storedCities.contains(city)) {
          selectedCities = [...storedCities, city];
          prefs.setStringList('cities', selectedCities);
          _cityFieldController.clear();
          _goToHome();
        } else {
          showSnackBar('City already present');
        }
      }
    } else {
      print("city is null");
      showSnackBar("city can't be empty");
    }
  }

  Future<List> _loadSavedCities() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getStringList('cities') != null &&
        prefs.getStringList('cities').isNotEmpty) {
      return prefs.getStringList('cities');
    }
  }

  void _goToHome() {
    Navigator.pushNamed(context, 'home');
  }

  void showSnackBar(String text) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: new Text(
      text,
      style: snackBarText(),
    )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
                  autofocus: true,
                  decoration: new InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search, color: Colors.redAccent),
                      onPressed: () => _cityFieldController.clear(),
                    ),
                    hintText: 'Add city',
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
                child: ListTile(
                  title: RaisedButton(
                    splashColor: Colors.black26,
                    disabledColor: Colors.grey,
                    elevation: 15.0,
                    onPressed: () {
                      _saveCities(_cityFieldController.text.toLowerCase());
                    },
                    color: Colors.redAccent,
                    textColor: Colors.white70,
                    child: Text(
                      "Add",
                      style: btnText(),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

//style

TextStyle inputStyle() {
  return GoogleFonts.josefinSans(
      textStyle: TextStyle(
          color: Colors.redAccent,
          fontStyle: FontStyle.normal,
          fontSize: 20.0));
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
          fontSize: 19.0, fontWeight: FontWeight.bold, color: Colors.white));
}

TextStyle snackBarText() {
  return GoogleFonts.josefinSans(
      textStyle: TextStyle(
          fontSize: 19.0, fontWeight: FontWeight.normal, color: Colors.white));
}
