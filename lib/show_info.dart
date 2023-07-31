//show_info.dart file

import 'package:contacts/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart' as urllauncher;

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

// ignore: camel_case_types, must_be_immutable
class showInfo extends StatefulWidget {
  final List<String> contacts;
  int index = -1;

  showInfo({super.key, required this.contacts, required this.index});

  @override
  State<showInfo> createState() => _showInfoState();
}

String extractNumbersAfterColon(String inputString) {
  // Find the location of the first ':'
  int colonIndex = inputString.indexOf(':');

  // If the ':' is not found or it's the last character, return an empty string
  if (colonIndex == -1 || colonIndex == inputString.length - 1) {
    return '';
  }

  // Extract the substring after ':' and remove all non-digit characters
  String resultString =
      inputString.substring(colonIndex + 1).replaceAll(RegExp(r'[^0-9]'), '');

  return resultString;
}

// ignore: camel_case_types
class _showInfoState extends State<showInfo> {
  late TextEditingController editController = TextEditingController();
  late TextEditingController phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('View Contact'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            widget.contacts.removeAt(widget.index);
            try {
              sharedPrefs myPrefs = sharedPrefs();
              myPrefs.init();
              myPrefs.setPref(widget.contacts);
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return const rootPage();
              }));
            } catch (e) {
              debugPrint(e.toString());
            }
          },
          child: const Icon(Icons.minimize),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.contacts[widget.index],
                style: const TextStyle(color: Color.fromARGB(255, 34, 52, 155)),
              ),
              TextField(
                controller: editController,
                decoration: const InputDecoration(labelText: 'Edit name'),
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Edit number'),
              ),
              ElevatedButton(
                onPressed: () {
                  widget.contacts[widget.index] =
                      '${editController.text} : ${phoneController.text}';
                  Navigator.of(context).pop();
                  try {
                    sharedPrefs myPref = sharedPrefs();
                    myPref.init();
                    myPref.setPref(widget.contacts);
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                      return const rootPage();
                    }));
                  } catch (e) {
                    debugPrint(e.toString());
                  }
                },
                child: const Text('Submit'),
              ),
              ElevatedButton(
                onPressed: () {
                  String num =
                      extractNumbersAfterColon(widget.contacts[widget.index]);
                  final Uri phoneUri = Uri(scheme: "tel", path: num);
                  urllauncher.launchUrl(phoneUri);
                },
                child: const Icon(Icons.call_made_rounded),
              )
            ],
          ),
        ));
  }
}
