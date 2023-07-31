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
}

void sortListAlphabetically(List<String> list) {
  list.sort((a, b) => a.compareTo(b));
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
    try {
      sharedPrefs myPref = sharedPrefs();
      myPref.init();
      contacts = myPref.getPref();
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
        backgroundColor: Colors.cyan,
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
