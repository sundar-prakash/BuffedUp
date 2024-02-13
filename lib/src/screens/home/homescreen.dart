import 'package:BuffedUp/const/Captions.dart';
import 'package:BuffedUp/const/DataTypes/UserProfile.dart';
import 'package:BuffedUp/src/screens/subscription/subscriptionscreen.dart';
import 'package:BuffedUp/src/screens/equipments/equipmentscreen.dart';
import 'package:BuffedUp/src/screens/members/memberscreen.dart';
import 'package:BuffedUp/src/screens/notes/notescreen.dart';
import 'package:BuffedUp/src/screens/settings/settingsScreen.dart';
import 'package:BuffedUp/src/screens/trainers/Trainerscreen.dart';
import 'package:BuffedUp/src/widget/homeprofile.dart';
import 'package:BuffedUp/src/widget/pagemenu.dart';
import 'package:BuffedUp/src/widget/searchindicator.dart';
import 'package:BuffedUp/src/widget/text.dart';
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
                  if (user.subscriptionHistory != null &&
                      user.subscriptionHistory!.isNotEmpty) {
                    //if subscripton has expired
                    if (DateTime.now()
                        .isAfter(user.subscriptionHistory![0].expiryDate)) {
                      return SubscribeScreen(
                          message: "Your current plan has been expired");
                    }
                  }

                  return SingleChildScrollView(
                    child: Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            homeprofile(user),
                            Padding(
                                padding: EdgeInsets.all(10),
                                child: BigText(getGreeting(name: user.name),
                                    bold: true)),
                            pagemenu(
                              "Members",
                              Icons.group,
                              user.members.length.toString(),
                              navigator: const MemberScreen(),
                              subtext: "Many people!",
                            ),
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
                            pagemenu(
                              "Notes",
                              Icons.note_add_outlined,
                              "Tap",
                              subtext: user.notes!.text,
                              navigator: NoteScreen(),
                            ),
                            pagemenu(
                              "Settings",
                              Icons.settings,
                              "",
                              subtext: "only for elite trainers",
                              navigator: SettingsScreen(user),
                            ),
                            // pagemenu(
                            //   "For Developers",
                            //   Icons.developer_board,
                            //   "! 4 u",
                            //   subtext: "Dont click mfer",
                            //   navigator: FirestoreImportScreen(),
                            // ),
                          ],
                        )),
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
