
import 'package:BuffedUp/src/widget/trainerform.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AddTrainerScreen extends StatelessWidget {
  const AddTrainerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add new Trainer"),
      ),
      body: Container(margin: const EdgeInsets.all(10), child: const TrainerForm()),
    );
  }
}
