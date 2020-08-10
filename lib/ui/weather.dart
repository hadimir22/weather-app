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
      return new ChangeCity();
    }));

    if (results != null && results.containsKey('enter')) {
      print(results['enter'].toString());
      _cityEntered = results['enter'];
      print(_cityEntered);
      print('recieved');
    }
  }

  //named navigation
  _goToAddCities() {
    Navigator.pushNamed(context, '/addCities');
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
    return new Scaffold(
      appBar: new AppBar(
          title: new Text('Weather'),
          backgroundColor: Colors.redAccent,
          actions: <Widget>[
            new IconButton(
                icon: new Icon(Icons.menu),
                onPressed: () {
                  _goToNextScreen(context);
                })
          ]),
      body: new Stack(children: <Widget>[
        new Center(
            child: new Image.asset('images/umbrella.png',
                width: 490.0, height: 1200.0, fit: BoxFit.fill)),
        new Container(
            alignment: Alignment.topRight,
            margin: const EdgeInsets.fromLTRB(0.0, 10.9, 20.5, 0.0),
            child: new Text(
              '${_cityEntered == null ? utils.defaultCity : _cityEntered}',
              style: cityStyle(),
            )),
        new Container(
          alignment: Alignment.center,
          child: new Image.asset('images/light_rain.png'),
        ),
        updateTempWidget(_cityEntered),
      ]),
      floatingActionButton: new FloatingActionButton(
          tooltip: 'Add Item',
          backgroundColor: Colors.redAccent,
          child: new ListTile(title: new Icon(Icons.add)),
          onPressed: (){
            _goToAddCities();
          } ),
    );
  }
}

class ChangeCity extends StatelessWidget {
  final _cityFieldController = new TextEditingController();

  _saveCities(String city) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('cities', city);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Change City'),
        backgroundColor: Colors.redAccent,
      ),
      body: new Stack(children: <Widget>[
        new Center(
            child: new Image.asset('images/white_snow.png',
                width: 490.0, height: 1200.0, fit: BoxFit.fill)),
        new ListView(children: <Widget>[
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
                  child: new Text("get Weather")))
        ])
      ]),
    );
  }
}

TextStyle cityStyle() {
  return new TextStyle(
      color: Colors.white, fontSize: 22.9, fontStyle: FontStyle.italic);
}

TextStyle weatherStyle() {
  return new TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w400,
      fontSize: 49.9,
      fontStyle: FontStyle.normal);
}

TextStyle description() {
  return new TextStyle(
      color: Colors.white70, fontSize: 17.0, fontStyle: FontStyle.normal);
}
