//add_contacts.dart file

import 'package:contacts/main.dart';
import 'package:flutter/material.dart';
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

//AddContactPage class as stateful-widget
class AddContactPage extends StatefulWidget {
  final List<String> contacts;

  const AddContactPage({super.key, required this.contacts});

  @override
  // ignore: library_private_types_in_public_api
  _AddContactPageState createState() => _AddContactPageState();
}

//_AddContactPageState
class _AddContactPageState extends State<AddContactPage> {
  late TextEditingController nameController;
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    phoneController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void sortListAlphabetically(List<String> list) {
    list.sort((a, b) => a.compareTo(b));
  }

  void _addContact() {
    String name = nameController.text;
    String phone = phoneController.text;
    if (name.isNotEmpty && phone.isNotEmpty) {
      String newContact = '$name : $phone';
      setState(() {
        widget.contacts.add(newContact);
        // ignore: non_constant_identifier_names
        List<String> ReversedList;
        ReversedList = widget.contacts.reversed.toList();
        sortListAlphabetically(ReversedList);
        try {
          sharedPrefs myPrefs = sharedPrefs();
          myPrefs.init();
          myPrefs.setPref(ReversedList);
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return const rootPage();
          }));
        } catch (e) {
          debugPrint(e.toString());
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addContact,
              child: const Text('Add Contact'),
            ),
          ],
        ),
      ),
    );
  }
}
