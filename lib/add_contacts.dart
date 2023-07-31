import 'package:contacts/main.dart';
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

class AddContactPage extends StatefulWidget {
  final List<String> contacts;

  const AddContactPage({super.key, required this.contacts});

  @override
  // ignore: library_private_types_in_public_api
  _AddContactPageState createState() => _AddContactPageState();
}

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
