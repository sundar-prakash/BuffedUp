// ignore_for_file: camel_case_types

import 'package:BuffedUp/const/DataTypes/GymMember.dart';
import 'package:BuffedUp/const/DataTypes/UserProfile.dart';
import 'package:BuffedUp/src/screens/profile/profile.dart';
import 'package:BuffedUp/src/widget/imageviewer.dart';
import 'package:flutter/material.dart';

String getGreeting({String? name}) {
  DateTime now = DateTime.now();
  int hour = now.hour;

  if (hour < 12) {
    return 'Good morning ! $name,';
  } else if (hour < 18) {
    return 'Good afternoon ! $name,';
  } else {
    return 'Good evening ! $name,';
  }
}

// ignore: must_be_immutable
class homeprofile extends StatelessWidget {
  UserProfile user;
  homeprofile(this.user, {super.key});

  @override
  Widget build(BuildContext context) {
    bool isSubscribed = user.subscriptionHistory != null &&
        user.subscriptionHistory!.isNotEmpty;
    bool isPremium = user.subscriptionHistory!.isNotEmpty
        ? user.subscriptionHistory![0].planID.toString().startsWith('2')
        : false;

    return GestureDetector(
        onDoubleTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => ProfileScreen(user))),
        child: Container(
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
              gradient: const LinearGradient(
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
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.fromLTRB(40, 60, 40, 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 24.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      "${user.gymName} Gym",
                      style: const TextStyle(
                        fontSize: 15.0,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    if (isSubscribed)
                      Row(
                        children: [
                          Column(
                            children: [
                              const Text(
                                "Paid on",
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                DateTimetoString(
                                    user.subscriptionHistory![0].paidOn),
                                style: const TextStyle(
                                  fontSize: 12.0,
                                  fontFamily: 'credc',
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Column(
                            children: [
                              const Text(
                                "Expires",
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                DateTimetoString(
                                    user.subscriptionHistory![0].expiryDate),
                                style: const TextStyle(
                                  fontSize: 12.0,
                                  fontFamily: 'credc',
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                  ],
                ),
                Column(
                  children: [
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
                            radius: 40,
                          )),
                    ),
                    if (isSubscribed &&
                        DateTime.now()
                            .isBefore(user.subscriptionHistory![0].expiryDate))
                      OutlinedButton(
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(
                              isPremium ? Colors.amber : Colors.white),
                          side: MaterialStateProperty.all<BorderSide>(
                            BorderSide(
                                color: isPremium ? Colors.amber : Colors.white),
                          ),
                        ),
                        child: Text(isPremium ? "Premium" : "Subscribed"),
                        onPressed: null,
                      )
                  ],
                ),
              ],
            )));
  }
}
