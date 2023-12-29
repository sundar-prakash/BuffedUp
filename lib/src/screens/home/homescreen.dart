import 'package:BuffedUp/const/Captions.dart';
import 'package:BuffedUp/const/DataTypes/UserProfile.dart';
import 'package:BuffedUp/src/screens/equipments/equipmentscreen.dart';
import 'package:BuffedUp/src/screens/members/memberscreen.dart';
import 'package:BuffedUp/src/screens/trainers/Trainerscreen.dart';
import 'package:BuffedUp/src/services/firestore/_migrate.dart';
import 'package:BuffedUp/src/widget/homeprofile.dart';
import 'package:BuffedUp/src/widget/pagemenu.dart';
import 'package:BuffedUp/src/widget/searchindicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(title),
          elevation: 3,
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('gymowner')
                .doc(FirebaseAuth.instance.currentUser?.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                final userProfileData = snapshot.data!.data();
                if (userProfileData != null) {
                  final user = UserProfile.fromMap(userProfileData);

                  return SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        homeprofile(user),
                        pagemenu(
                          "Members",
                          Icons.group,
                          user.members.length.toString(),
                          navigator: const MemberScreen(),
                          subtext: "Many people!",
                        ),
                        // pagemenu(
                        //   "Expenses",
                        //   Icons.attach_money,
                        //   "00",
                        //   subtext: "Poor guy:(",
                        // ),
                        pagemenu(
                          "Trainers",
                          Icons.school,
                          user.trainers.length.toString(),
                          subtext: "69 more rep...",
                          navigator: const TrainerScreen(),
                        ),
                        pagemenu(
                          "Equipment",
                          Icons.fitness_center,
                          user.equipments.length.toString(),
                          subtext: "Light weight baby",
                          navigator: const EquipmentScreen(),
                        ),
                        // pagemenu(
                        //   "For Developers",
                        //   Icons.developer_board,
                        //   "! 4 u",
                        //   subtext: "Dont click mfer",
                        //   navigator: FirestoreImportScreen(),
                        // ),
                      ],
                    ),
                  );
                } else {
                  return SearchingIndicator();
                }
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return Center(child: SearchingIndicator());
              }
            }));
  }
}
