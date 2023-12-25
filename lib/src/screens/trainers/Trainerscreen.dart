import 'package:BuffedUp/const/DataTypes/Trainers.dart';
import 'package:BuffedUp/const/DataTypes/UserProfile.dart';
import 'package:BuffedUp/src/screens/trainers/AddTrainer.dart';
import 'package:BuffedUp/src/widget/TrainerCard.dart';
import 'package:BuffedUp/src/widget/searchindicator.dart';
import 'package:BuffedUp/src/widget/text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TrainerScreen extends StatelessWidget {
  const TrainerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Trainer"),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddTrainerScreen()),
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
            List<Trainer> trainers =
                user.trainers.map((e) => Trainer.fromMap(e)).toList();

            return trainers.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: trainers
                                .map((e) => TrainerCard(e))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  )
                : const Center(child: MediumText("Gym with no Trainers!"));
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
