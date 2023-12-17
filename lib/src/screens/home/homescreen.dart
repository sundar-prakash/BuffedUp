import 'package:BuffedUp/const/Captions.dart';
import 'package:BuffedUp/const/DataTypes.dart';
import 'package:BuffedUp/src/screens/members/memberscreen.dart';
import 'package:BuffedUp/src/widget/homeprofile.dart';
import 'package:BuffedUp/src/widget/pagemenu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: camel_case_types
class homescreen extends StatelessWidget {
  const homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(title),
          elevation: 3,
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser?.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final userProfileData = snapshot.data!.data();
                final user = UserProfile.fromMap(userProfileData!);

                return SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      homeprofile(user),
                      pagemenu(
                        "Members",
                        Icons.group,
                        user.members.length.toString(),
                        navigator: memberscreen(),
                        subtext: "Many people!",
                      ),
                      pagemenu(
                        "Expenses",
                        Icons.attach_money,
                        "00",
                        subtext: "Poor guy:(",
                      ),
                      pagemenu(
                        "Trainers",
                        Icons.school,
                        "00",
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
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return const Center(
                    child: CupertinoActivityIndicator(
                  radius: 30,
                ));
              }
            }));
  }
}
