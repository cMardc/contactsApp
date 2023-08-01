import 'package:flutter/material.dart';
import 'show_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: camel_case_types
class sharedPrefs {
  static late SharedPreferences preferences;

  Future<void> init() async {
    preferences = await SharedPreferences.getInstance();
  }

  Future<void> setPref(List<String> input) async {
    preferences = await SharedPreferences.getInstance();
    preferences.setStringList('contlist', input);
  }

  List<String> getPref() {
    return preferences.getStringList('contlist') ?? [];
  }

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

class Phone extends StatefulWidget {
  final List<String> myList;

  const Phone({Key? key, required this.myList}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PhoneState createState() => _PhoneState();
}

void sortListAlphabetically(List<String> list) {
  list.sort((a, b) => a.compareTo(b));
}

class _PhoneState extends State<Phone> {
  int index = 0;
  Color backgroundColor = Colors.cyan;
  List<String> filteredList = [];

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    try {
      sharedPrefs myPrefs = sharedPrefs();
      await myPrefs.init();
      backgroundColor = myPrefs.getClr();
      setState(() {});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  filteredList = widget.myList
                      .where((name) =>
                          name.toLowerCase().contains(value.toLowerCase()))
                      .toList();
                });
              },
              decoration: const InputDecoration(
                hintText: 'Search...',
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredList.isEmpty
                  ? widget.myList.length
                  : filteredList.length,
              itemBuilder: (context, index) {
                final String contactName = filteredList.isEmpty
                    ? widget.myList[index]
                    : filteredList[index];

                return ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return showInfo(
                              contacts: widget.myList, index: index);
                        },
                      ),
                    );
                  },
                  child: Text(contactName),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          try {
            index += 1;
            List<MaterialColor> colors = [
              Colors.cyan,
              Colors.yellow,
              Colors.red,
              Colors.green,
              Colors.blue,
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
        child: const Icon(Icons.color_lens),
      ),
      backgroundColor: backgroundColor,
    );
  }
}
