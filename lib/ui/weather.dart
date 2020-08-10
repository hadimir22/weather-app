import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import './util/utils.dart' as utils;

class Weather extends StatefulWidget {
  @override
  _WeatherState createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  String _cityEntered;
  String _savedCities = "";

  @override
  void initState() {
    // This is called on init
    super.initState();
    _loadSavedCities();
  }

  _loadSavedCities() async {
    print("cdm");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.getString('cities') != null &&
          prefs.getString('cities').isNotEmpty) {
        _savedCities = prefs.getString('cities');
      } else {}
      print(_savedCities);
    });
  }

  void fetchData() async {
    Map data = await getWeather(utils.apiKey, utils.defaultCity);
    print(data.toString());
  }

  Future<Map> getWeather(String apiKey, String city) async {
    String apiURL = "${utils.apiURL}$city&APPID=${utils.apiKey}&units=metric";
    http.Response response = await http.get(apiURL);
    return json.decode(response.body);
  }

//navigatin
  Future _goToNextScreen(BuildContext context) async {
    Map results = await Navigator.of(context)
        .push(new MaterialPageRoute<Map>(builder: (BuildContext context) {
//      return new ChangeCity();
    }));

    if (results != null && results.containsKey('enter')) {
      print(results['enter'].toString());
      _cityEntered = results['enter'];
      print(_cityEntered);
      print('recieved');
    }
  }

  //named navigation
  void _goToAddCities() {
    Navigator.pushNamed(context, '/addCities');
  }

  void _goToManageCities() {
    Navigator.pushNamed(context, '/manageCities');
  }

  Widget updateTempWidget(String city) {
    return new FutureBuilder(
        future:
            getWeather(utils.apiKey, city == null ? utils.defaultCity : city),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          //this is where we get all of the JSON data, we set up widgets etc.
          if (snapshot.hasData) {
            Map content = snapshot.data;
            return new Container(
                margin: const EdgeInsets.fromLTRB(30.0, 250.0, 0.0, 0.0),
                child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new ListTile(
                        title: new Text(
                          content['main']['temp'].toString(),
                          style: weatherStyle(),
                        ),
                        subtitle: new ListTile(
                            title: new Text(
                          "Humidity : ${content['main']['humidity'].toString()}\n"
                          "Min : ${content['main']['temp_min'].toString()}\n"
                          "Max : ${content['main']['temp_max'].toString()}\n",
                          style: description(),
                        )),
                      )
                    ]));
          } else {
            return new Container();
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(
//        title: Center(
//          child: Text('Weatherman'),
//        ),
//        backgroundColor: Colors.redAccent,
//      ),
      body: Stack(children: <Widget>[
        Center(
            child: Image.asset('images/umbrella.png',
                width: 490.0, height: 1200.0, fit: BoxFit.fill)),
        Container(
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
        ),
        Container(
            alignment: Alignment.topCenter,
            margin: const EdgeInsets.fromLTRB(0.0, 250.9, 0.0, 0.0),
            child: Text(
              '${_cityEntered == null ? utils.defaultCity : _cityEntered}',
              style: cityStyle(),
            )),
        updateTempWidget(_cityEntered),
      ]),
//      floatingActionButton: new FloatingActionButton(
//          tooltip: 'Add Item',
//          backgroundColor: Colors.redAccent,
//          child: ListTile(title: new Icon(Icons.add)),
//          onPressed: () {
//            _goToAddCities();
//          }),
    );
  }
}

//Style
TextStyle cityStyle() {
  return TextStyle(
      color: Colors.white, fontSize: 22.9, fontStyle: FontStyle.italic);
}

TextStyle weatherStyle() {
  return TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w400,
      fontSize: 49.9,
      fontStyle: FontStyle.normal);
}

TextStyle description() {
  return TextStyle(
      color: Colors.white70, fontSize: 17.0, fontStyle: FontStyle.normal);
}

TextStyle navText() {
  return TextStyle(
    color: Colors.white,
    fontSize: 20.0,
  );
}
