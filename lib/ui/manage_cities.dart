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

//    print('meaow ${await _loadSavedCities()}');
    print('jios ${storedCities}');
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

  // Used to build list items that haven't been removed.
  Widget _buildItem(
      BuildContext context, int index, Animation<double> animation) {
    return CardItem(
      animation: animation,
      item: storedCities[index],
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
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: AnimatedList(
            key: _listKey,
            initialItemCount: storedCities.length,
            itemBuilder: _buildItem,
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

class CardItem extends StatelessWidget {
  const CardItem(
      {Key key,
      @required this.animation,
      this.onTap,
      @required this.item,
      this.selected = false})
      : assert(animation != null),
        assert(item != null && item >= 0),
        assert(selected != null),
        super(key: key);

  final Animation<double> animation;
  final VoidCallback onTap;
  final int item;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.headline4;
    if (selected)
      textStyle = textStyle.copyWith(color: Colors.lightGreenAccent[400]);
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: SizeTransition(
        axis: Axis.vertical,
        sizeFactor: animation,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: SizedBox(
            height: 80.0,
            child: Card(
              color: Colors.primaries[item % Colors.primaries.length],
              child: Center(
                child: Text('Item $item', style: textStyle),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
