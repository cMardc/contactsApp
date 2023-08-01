//main.dart file

//Import packages that will be used
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'add_contacts.dart';
import 'phone.dart';

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
    //preferences = await SharedPreferences.getInstance();
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

//Function to run when started
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Try to start shared preferences
  try {
    sharedPrefs myPref = sharedPrefs();
    myPref.init();
  } catch (e) {
    debugPrint(e.toString());
  }
  runApp(const MyApp());
}

//Stateless-widget (unchangeable) screen
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  //Get primary color
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

//Stateful (changeable) screen
// ignore: camel_case_types
class rootPage extends StatefulWidget {
  const rootPage({super.key});

  @override
  State<rootPage> createState() => _rootPageState();
}

//_rootPageState to update screen
// ignore: camel_case_types
class _rootPageState extends State<rootPage>
    with SingleTickerProviderStateMixin {
  //Animation controller for refresh (leading) button
  AnimationController? _controller;

  //Page value
  int page = 0;

  //List of contacts => (${name} + ' : ' + ${number})
  List<String> contacts = [];

  //Check if screen is refreshing
  bool isRefreshing = false;

  @override

  //Starting animation controller
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  //Stopping animation controller
  void stopAnimation() {
    _controller!.stop();
    _controller!.reset();
  }

  //Disposing animation controller
  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  //Build function
  Widget build(BuildContext context) {
    //Get initial background color
    Color backgroundColor = Colors.cyan;

    //try to get color and list of contacts
    try {
      sharedPrefs myPref = sharedPrefs();
      myPref.init();
      contacts = myPref.getPref();
      myPref.init();
      backgroundColor = myPref.getClr();
    } catch (e) {
      debugPrint(e.toString());
    }
    //Sort contacts list alphabetically
    sortListAlphabetically(contacts);

    //List of pages for app
    List<Widget> bodies = [
      Phone(myList: contacts),
      AddContactPage(contacts: contacts)
    ];

    //Main scaffold
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),

        //Load background color
        backgroundColor: backgroundColor,

        //Leading (refreshing) button on app-bar
        leading: GestureDetector(
          onTap: () {
            //Load root page when pressed
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (BuildContext context) {
              return const rootPage();
            }));
          },
          //Animation controls
          child: AnimatedBuilder(
              animation: _controller!,
              builder: (context, child) {
                //Rotate/spin animation
                return RotationTransition(
                    turns: _controller!,
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          isRefreshing = true;
                        });
                        //Repeat it
                        _controller!.repeat();
                        Future.delayed(
                          const Duration(seconds: 1),
                          stopAnimation,
                        );
                      },
                      //Refresh icon for button
                      icon: const Icon(Icons.refresh),
                    ));
              }),
        ),
      ),
      //Select page to load
      body: bodies[page],
      //Navigation Bar to change pages
      bottomNavigationBar: NavigationBar(
        destinations: const [
          //Destination pages
          NavigationDestination(icon: Icon(Icons.person), label: 'Contacts'),
          NavigationDestination(icon: Icon(Icons.add), label: 'Add'),
        ],
        onDestinationSelected: (int selected) {
          //Change index/page when selected
          setState(() {
            page = selected;
            debugPrint(page.toString());
          });
        },
        //Change current page
        selectedIndex: page,
      ),
    );
  }
}
