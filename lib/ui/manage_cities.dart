import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManageCities extends StatefulWidget {
  @override
  _ManageCitiesState createState() => _ManageCitiesState();
}

class _ManageCitiesState extends State<ManageCities> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  String _cityEntered;
  String _savedCities = "";
  dynamic storedCities;

  @override
  void initState() {
    // This is called on init
    super.initState();
    getCities();
  }

  getCities() async {
    var citiesTempHolder = await _loadSavedCities();
    if (citiesTempHolder != null && citiesTempHolder.isNotEmpty) {
      setState(() {
        storedCities = citiesTempHolder;
      });
    }
  }

  Future<List> _loadSavedCities() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getStringList('cities') != null &&
        prefs.getStringList('cities').isNotEmpty) {
      return prefs.getStringList('cities');
    } else {
      print('no city');
    }
  }

  void _removeCity(int index, String city) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var citiesTempHolder = await _loadSavedCities();
    print('temp, $citiesTempHolder');
    citiesTempHolder.remove(city);
    print('after $citiesTempHolder');
    await prefs.setStringList('cities', citiesTempHolder);

    int removeIndex = index;
    String removedItem = storedCities.removeAt(removeIndex);
    AnimatedListRemovedItemBuilder builder = (context, animation) {
      return _buildItem(removedItem, index, animation);
    };
    _listKey.currentState.removeItem(removeIndex, builder);
  }

  Widget _buildItem(String item, index, Animation animation) {
    print('hi thr l ${storedCities.length}');
    return SizeTransition(
      sizeFactor: animation,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                item,
                style: listStyle(),
              ),
              IconButton(
                icon: Icon(
                  Icons.remove_circle,
                  size: 20.0,
                  color: Colors.redAccent,
                ),
                onPressed: () {
                  _removeCity(index, item);
                },
              )
            ],
          ),
        ),
      ),
    );
  }

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
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: AnimatedList(
            key: _listKey,
            initialItemCount: storedCities.length,
            itemBuilder: (context, index, animation) {
              return _buildItem(storedCities[index], index, animation);
            },

//            _buildItem,
          ),
        ));
  }
}

TextStyle screenName() {
  return GoogleFonts.josefinSans(textStyle: TextStyle());
}

TextStyle screensName() {
  return GoogleFonts.josefinSans(
      textStyle: TextStyle(backgroundColor: Colors.redAccent));
}

TextStyle listStyle() {
  return GoogleFonts.josefinSans(
      textStyle: TextStyle(
          color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold));
}
