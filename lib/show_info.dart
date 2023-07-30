import 'package:flutter/material.dart';
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
}

// ignore: camel_case_types, must_be_immutable
class showInfo extends StatefulWidget {
  final List<String> contacts;
  int index = -1;

  showInfo({super.key, required this.contacts, required this.index});

  @override
  State<showInfo> createState() => _showInfoState();
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
            } catch (e) {
              debugPrint(e.toString());
            }
            Navigator.of(context).pop();
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
                  } catch (e) {
                    debugPrint(e.toString());
                  }
                },
                child: const Text('Submit'),
              )
            ],
          ),
        ));
  }
}
