// ignore_for_file: camel_case_types

import 'package:BuffedUp/const/DataTypes/UserProfile.dart';
import 'package:BuffedUp/src/screens/profile/profile.dart';
import 'package:BuffedUp/src/widget/imageviewer.dart';
import 'package:BuffedUp/src/widget/text.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class homeprofile extends StatelessWidget {
  UserProfile user;
  homeprofile(this.user, {super.key});
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
    return GestureDetector(
        onDoubleTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => ProfileScreen(user))),
        child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromARGB(255, 115, 88, 252),
                  Color(0xFF755EE8),
                  Colors.purpleAccent,
                  Color.fromARGB(255, 231, 71, 252),
                  Colors.amber,
                ],
              ),
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
                    Row(
                      children: [
                        BigText(
                          "Hello, ${user.name}",
                          bold: true,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        if (user.subscriptionHistory![0].planID
                            .toString()
                            .startsWith('2'))
                          OutlinedButton(
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.amber),
                              side: MaterialStateProperty.all<BorderSide>(
                                BorderSide(color: Colors.amber),
                              ),
                            ),
                            child: Text("Premium"),
                            onPressed: null,
                          )
                      ],
                    ),
                    BigText(getGreeting()),
                    MediumText(
                      "${user.gymName} Gym",
                      bold: true,
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () async {
                    await showDialog(
                        context: context,
                        builder: (_) => ImageDialog(user.avatar));
                  },
                  child: Hero(
                      tag: "avatar",
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(user.avatar),
                        radius: 50,
                      )),
                ),
              ],
            )));
  }
}
