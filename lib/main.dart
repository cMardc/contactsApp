import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'add_contacts.dart';
import 'phone.dart';

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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await SharedPreferences.getInstance();
  try {
    sharedPrefs myPref = sharedPrefs();
    myPref.init();
  } catch (e) {
    debugPrint(e.toString());
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: const rootPage(),
    );
  }
}

// ignore: camel_case_types
class rootPage extends StatefulWidget {
  const rootPage({super.key});

  @override
  State<rootPage> createState() => _rootPageState();
}

// ignore: camel_case_types
class _rootPageState extends State<rootPage> {
  int page = 0;
  //SharedPreferences pref = SharedPreferences.getInstance();
  List<String> contacts = [];

  @override
  Widget build(BuildContext context) {
    try {
      sharedPrefs myPref = sharedPrefs();
      myPref.init();
      contacts = myPref.getPref();
    } catch (e) {
      debugPrint(e.toString());
    }
    List<Widget> bodies = [
      Phone(myList: contacts),
      AddContactPage(contacts: contacts)
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return const rootPage();
              }));
            },
            icon: const Icon(Icons.refresh)),
      ),
      body: bodies[page],
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.person), label: 'Contacts'),
          NavigationDestination(icon: Icon(Icons.add), label: 'Add'),
        ],
        onDestinationSelected: (int selected) {
          setState(() {
            page = selected;
            debugPrint(page.toString());
          });
        },
        selectedIndex: page,
      ),
    );
  }
}
