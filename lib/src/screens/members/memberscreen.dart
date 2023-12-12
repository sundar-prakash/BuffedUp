// ignore_for_file: camel_case_types

import 'package:BuffedUp/src/screens/members/newmemberscreen.dart';
import 'package:BuffedUp/src/screens/members/viewmemberscreen.dart';
import 'package:BuffedUp/src/widget/membertile.dart';
import 'package:flutter/material.dart';

class memberscreen extends StatefulWidget {
  const memberscreen({super.key});

  @override
  State<memberscreen> createState() => _memberscreenState();
}

class _memberscreenState extends State<memberscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 2,
          title: const Text("Members"),
          actions: [
            IconButton(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => newmemberscreen())),
                icon: const Icon(Icons.add_circle_outline))
          ],
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const TextField(
                decoration: InputDecoration(
                    label: Text("Search name,reg,phone..."),
                    prefixIcon: Icon(Icons.search)),
              ),
              Column(
                children: [
                  membertile("sasuke", 45),
                  membertile("naruto", 435),
                  membertile("kakashi", 15),
                ],
              )
            ],
          ),
        ));
  }
}
