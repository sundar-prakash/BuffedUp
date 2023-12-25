import 'package:BuffedUp/const/DataTypes/Equipment.dart';
import 'package:BuffedUp/const/DataTypes/UserProfile.dart';
import 'package:BuffedUp/src/screens/equipments/addequipment.dart';
import 'package:BuffedUp/src/widget/equipmentcard.dart';
import 'package:BuffedUp/src/widget/searchindicator.dart';
import 'package:BuffedUp/src/widget/text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EquipmentScreen extends StatelessWidget {
  const EquipmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Equipments"),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddEquipmentScreen()),
            ),
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('gymowner')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            final userProfileData = snapshot.data!.data();
            final user = UserProfile.fromMap(userProfileData!);
            List<EquipmentType> equipments =
                user.equipments.map((e) => EquipmentType.fromMap(e)).toList();

            return equipments.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: equipments
                                .map((e) => EquipmentCard(e))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  )
                : const Center(child: MediumText("Empty gym!"));
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Center(child: SearchingIndicator());
          }
        },
      ),
    );
  }
}
