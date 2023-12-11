// ignore_for_file: camel_case_types

import 'package:fitrack/src/widget/Text.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class homeprofile extends StatelessWidget {
  String name;
  String email;
  String? avatar;
  homeprofile(this.name, this.email, {this.avatar, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 123, 147, 226),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(40, 60, 40, 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BigText("Hello, $name"),
                MediumText("Good Evening"),
              ],
            ),
            CircleAvatar(
              radius: 50,
              backgroundColor: Color.fromARGB(255, 212, 166, 155),
              child: avatar != null
                  ? Image.network(avatar!)
                  : Text(name.substring(0, 1)),
            ),
          ],
        ));
  }
}
