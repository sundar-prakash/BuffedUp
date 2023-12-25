import 'package:BuffedUp/src/widget/equipmentform.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AddEquipmentScreen extends StatelessWidget {
  const AddEquipmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add new Equipment"),
      ),
      body: Container(margin: const EdgeInsets.all(10), child: const EquipmentForm()),
    );
  }
}
