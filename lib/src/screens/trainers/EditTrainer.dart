import 'package:BuffedUp/const/DataTypes/Trainers.dart';
import 'package:BuffedUp/src/widget/trainerform.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class EditTrainerScreen extends StatelessWidget {
  Trainer trainer;

  EditTrainerScreen(this.trainer, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit ${trainer.name}"),
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: TrainerForm(trainer: trainer),
      ),
    );
  }
}
