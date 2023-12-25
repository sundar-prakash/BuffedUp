import 'package:BuffedUp/const/DataTypes/Equipment.dart';
import 'package:BuffedUp/src/widget/equipmentform.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class EditEquipmentScreen extends StatelessWidget {
  EquipmentType equipment;

  EditEquipmentScreen(this.equipment, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit ${equipment.name}"),
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: EquipmentForm(equipment: equipment),
      ),
    );
  }
}
