// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'show_info.dart';

class Phone extends StatefulWidget {
  final List<String> myList;

  const Phone({Key? key, required this.myList}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PhoneState createState() => _PhoneState();
}

class _PhoneState extends State<Phone> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: widget.myList.length,
        itemBuilder: (context, index) {
          return ElevatedButton(
            onPressed: () {
              setState(() {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return showInfo(contacts: widget.myList, index: index);
                }));
                showInfo(contacts: widget.myList, index: index);
              });
            },
            child: Text(widget.myList[index]),
          );
        },
      ),
    );
  }
}
