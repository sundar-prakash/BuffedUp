// ignore_for_file: camel_case_types

import 'package:BuffedUp/src/widget/text.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class homeprofile extends StatelessWidget {
  String name;
  String? avatar;
  homeprofile(this.name, {this.avatar, super.key});
  String getGreeting() {
    DateTime now = DateTime.now();
    int hour = now.hour;

    if (hour < 12) {
      return 'Good morning!';
    } else if (hour < 18) {
      return 'Good afternoon!';
    } else {
      return 'Good evening!';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              stops: [0, 1],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF3eafe1), Color(0xff6f67e8)]),
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
                MediumText(getGreeting()),
              ],
            ),
            CircleAvatar(
              radius: 50,
              backgroundColor: Color.fromARGB(255, 179, 123, 231),
              backgroundImage: avatar != null ? NetworkImage(avatar!) : null,
              child: Text(name.substring(0, 1)),
            ),
          ],
        ));
  }
}
