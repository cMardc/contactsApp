import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'add_contacts.dart';
import 'phone.dart';
import 'dart:math' as math;

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
class _rootPageState extends State<rootPage>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  int page = 0;
  //SharedPreferences pref = SharedPreferences.getInstance();
  List<String> contacts = [];

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
    List<Widget> bodies = [
      Phone(myList: contacts),
      AddContactPage(contacts: contacts)
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
        /*
        leading: IconButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return const rootPage();
              }));
            },
            icon: const Icon(Icons.refresh)),
            */
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (BuildContext context) {
              return const rootPage();
            }));
          },
          /*
          child: RotationTransition(
            turns: const AlwaysStoppedAnimation(0),
            child: IconButton(
              onPressed: () {
                _controller!.repeat();
              },
              icon: const Icon(Icons.refresh),
            ),
          ),
          */
          child: AnimatedBuilder(
              animation: _controller!,
              builder: (context, child) {
                return RotationTransition(
                    turns: _controller!,
                    child: IconButton(
                      onPressed: () {
                        _controller!.repeat();
                        Future.delayed(
                            const Duration(seconds: 1), stopAnimation);
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
