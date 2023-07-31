import 'dart:async';

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
class _rootPageState extends State<rootPage>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  int page = 0;
  List<String> contacts = [];
  bool isRefreshing =
      false; // Step 1: Add a boolean to track the refresh status

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  void stopAnimation() {
    _controller!.stop();
    _controller!.reset();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Colors.cyan;
    try {
      sharedPrefs myPref = sharedPrefs();
      myPref.init();
      contacts = myPref.getPref();
      myPref.init();
      backgroundColor = myPref.getClr();
    } catch (e) {
      debugPrint(e.toString());
    }
    sortListAlphabetically(contacts);
    List<Widget> bodies = [
      Phone(myList: contacts),
      AddContactPage(contacts: contacts)
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
        backgroundColor: backgroundColor,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (BuildContext context) {
              return const rootPage();
            }));
          },
          child: AnimatedBuilder(
              animation: _controller!,
              builder: (context, child) {
                return RotationTransition(
                    turns: _controller!,
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          isRefreshing = true;
                        });
                        _controller!.repeat();
                        Future.delayed(
                          const Duration(seconds: 1),
                          stopAnimation,
                        );
                      },
                      icon: const Icon(Icons.refresh),
                    ));
              }),
        ),
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
