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
          title: Text("Members"),
        ),
        body: Container(
          child: Column(
            children: [
              TextField(
                decoration:
                    InputDecoration(label: Text("Search name,reg,phone...")),
              ),
              Column()
            ],
          ),
        ));
  }
}
