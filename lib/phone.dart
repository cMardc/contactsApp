//phone.dart file

//Import packages that will be used
import 'package:flutter/material.dart';
import 'show_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Create a shared preferences class to store user data
// ignore: camel_case_types
class sharedPrefs {
  static late SharedPreferences preferences;

  //Init method to start
  Future<void> init() async {
    preferences = await SharedPreferences.getInstance();
  }

  //Setting contacts list to 'contlist' tag on memory
  Future<void> setPref(List<String> input) async {
    preferences = await SharedPreferences.getInstance();
    preferences.setStringList('contlist', input);
  }

  //Get contacts list with tag 'contlist'
  List<String> getPref() {
    return preferences.getStringList('contlist') ?? [];
  }

  //Set color on memory with 'clr' tag
  Future<void> setClr(Color input) async {
    preferences = await SharedPreferences.getInstance();
    if (input == Colors.cyan) {
      preferences.setInt('clr', 0);
    } else if (input == Colors.yellow) {
      preferences.setInt('clr', 1);
    } else if (input == Colors.red) {
      preferences.setInt('clr', 2);
    } else if (input == Colors.green) {
      preferences.setInt('clr', 3);
    } else if (input == Colors.blue) {
      preferences.setInt('clr', 4);
    } else {
      preferences.setInt('clr', 0);
    }
  }

  //Get color from memory with 'clr' tag
  Color getClr() {
    int val = preferences.getInt('clr') ?? 0;
    if (val == 0) {
      return Colors.cyan;
    } else if (val == 1) {
      return Colors.yellow;
    } else if (val == 2) {
      return Colors.red;
    } else if (val == 3) {
      return Colors.green;
    } else if (val == 4) {
      return Colors.blue;
    } else {
      return Colors.cyan;
    }
  }
}

//phone class (stateful-widget)
class Phone extends StatefulWidget {
  final List<String> myList;

  const Phone({Key? key, required this.myList}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PhoneState createState() => _PhoneState();
}

//Sort list in alphabetical order
void sortListAlphabetically(List<String> list) {
  list.sort((a, b) => a.compareTo(b));
}

//_PhoneState widget To Update Screen
class _PhoneState extends State<Phone> {
  //Index for contacts
  int index = 0;

  // Initialize with a default color
  Color backgroundColor = Colors.cyan;

  @override
  //Loading preferences
  void initState() {
    super.initState();
    _loadPreferences();
  }

  //load function
  Future<void> _loadPreferences() async {
    try {
      sharedPrefs myPrefs = sharedPrefs();
      await myPrefs.init();
      backgroundColor = myPrefs.getClr();
      setState(() {}); // To trigger a rebuild after preferences are loaded
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: widget.myList.length,
        itemBuilder: (context, index) {
          return ElevatedButton(
            onPressed: () {
              setState(() {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return showInfo(contacts: widget.myList, index: index);
                }));
                sortListAlphabetically(widget.myList);
                showInfo(contacts: widget.myList, index: index);
              });
            },
            child: Text(widget.myList[index]),
          );
        },
      ),
      //Change color button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //try to change color
          try {
            index += 1;
            List<MaterialColor> colors = [
              Colors.cyan,
              Colors.yellow,
              Colors.red,
              Colors.green,
              Colors.blue
            ];
            sharedPrefs myPrefs = sharedPrefs();
            if (index < colors.length) {
              backgroundColor = colors[index];
              myPrefs.setClr(backgroundColor);
              debugPrint(myPrefs.getClr().toString());
            } else {
              index = 0;
              backgroundColor = colors[index];
              myPrefs.setClr(backgroundColor);
              debugPrint(myPrefs.getClr().toString());
            }
          } catch (e) {
            debugPrint(e.toString());
          }
        },
        //Color icon
        child: const Icon(Icons.color_lens),
      ),
      // Set the background color
      backgroundColor: backgroundColor,
    );
  }
}
