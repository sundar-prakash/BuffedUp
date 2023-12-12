import 'package:BuffedUp/src/screens/members/memberscreen.dart';
import 'package:BuffedUp/src/widget/homeprofile.dart';
import 'package:BuffedUp/src/widget/pagemenu.dart';
import 'package:flutter/material.dart';

// ignore: camel_case_types
class homescreen extends StatelessWidget {
  const homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
          title: const Text("BuffedUp"),
          centerTitle: true,
          elevation: 3,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              homeprofile("Sundar", "edf@gmail.com"),
              pagemenu(
                "Members",
                Icons.group,
                "45",
                navigator: memberscreen(),
                subtext: "Many people!",
              ),
              pagemenu(
                "Expenses",
                Icons.attach_money,
                "9,000",
                subtext: "Poor guy:(",
              ),
              pagemenu(
                "Trainers",
                Icons.school,
                "02",
                subtext: "69 more...",
              ),
              pagemenu(
                "Equipment",
                Icons.fitness_center,
                "56",
                subtext: "too hEavy",
              ),
            ],
          ),
        ));
  }
}
