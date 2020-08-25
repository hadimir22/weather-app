import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManageCities extends StatefulWidget {
  @override
  _ManageCitiesState createState() => _ManageCitiesState();
}

class _ManageCitiesState extends State<ManageCities> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  dynamic storedCities;
  List<String> citiesToRemove = List<String>();
//  List<String> storedCities = List();

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
    } else {
      storedCities = [];
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
//
//
//
//

    citiesToRemove.add(city);

    int removeIndex = index;
    String removedItem = storedCities.removeAt(removeIndex);
    AnimatedListRemovedItemBuilder builder = (context, animation) {
      return _buildItem(removedItem, animation, index);
    };
    _listKey.currentState.removeItem(removeIndex, builder);
  }

  void save() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('cities to remove $citiesToRemove');
    if (citiesToRemove != null && citiesToRemove.isNotEmpty) {
      var citiesTempHolder = await _loadSavedCities();
      citiesToRemove.every((city) {
        citiesTempHolder.remove(city);
        return true;
      });
      await prefs.setStringList('cities', citiesTempHolder);
    }
    _goToHome();
  }

  void _goToHome() {
    Navigator.pushNamed(context, 'home');
  }

  Widget _buildItem(String item, Animation animation, int index) {
    return SizeTransition(
      sizeFactor: animation,
      child: Card(
        elevation: 3,
        child: ListTile(
          title: Text(
            item,
            style: listStyle(),
          ),
          trailing: storedCities.length > 1
              ? IconButton(
                  icon: Icon(
                    Icons.remove_circle,
                    size: 20.0,
                    color: Colors.redAccent,
                  ),
                  onPressed: () {
                    _removeCity(index, item);
                  },
                )
              : null,
          leading: CircleAvatar(
            backgroundColor: Colors.redAccent,
            child: Text(
              item[0],
              style: avatarText(),
            ),
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            flex: 10,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: AnimatedList(
                key: _listKey,
                initialItemCount: storedCities.length,
                itemBuilder: (context, index, animation) {
                  return _buildItem(storedCities[index], animation, index);
                },
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0.2, 0.0, 0.2, 10.0),
              child: ListTile(
                  title: RaisedButton(
                      splashColor: Colors.black26,
                      disabledColor: Colors.grey,
                      elevation: 15.0,
                      onPressed: () {
                        save();
                      },
                      color: Colors.redAccent,
                      textColor: Colors.white70,
                      child: Text(
                        "Save",
                        style: saveText(),
                      ))),
            ),
          )
        ],
      ),
    );
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

TextStyle avatarText() {
  return GoogleFonts.josefinSans(
      textStyle: TextStyle(
          color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold));
}

TextStyle saveText() {
  return GoogleFonts.josefinSans(
      textStyle: TextStyle(
          color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold));
}
