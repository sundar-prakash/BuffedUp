import 'package:BuffedUp/const/DataTypes/Equipment.dart';
import 'package:BuffedUp/src/screens/equipments/editequipment.dart';
import 'package:BuffedUp/src/services/firestore/ownerdoc.dart';
import 'package:BuffedUp/src/widget/Dialogs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EquipmentCard extends StatelessWidget {
  final EquipmentType equipment;

  const EquipmentCard(this.equipment, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 3,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Image.asset(
            "asset/equipmentplaceholder.jpg",
            height: 200,
            width: 300,
            fit: BoxFit.cover,
          ),
          Container(
            height: 160,
            width: 300,
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  equipment.name,
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "x${equipment.count}",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 10),
                if (equipment.description != null &&
                    equipment.description!.isNotEmpty)
                  Text(
                    "${equipment.description}",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[700],
                    ),
                  ),
                Row(
                  children: <Widget>[
                    const Spacer(),
                    TextButton(
                      child: const Text(
                        "EDIT",
                      ),
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  EditEquipmentScreen(equipment))),
                    ),
                    TextButton(
                      child: const Text(
                        "DELETE",
                      ),
                      onPressed: () {
                        late bool res;
                        showDialog(
                            context: context,
                            builder: (_) {
                              return DeleteConfirmationDialog(
                                  onConfirm: () async {
                                res = await updateOwner(
                                    'equipments',
                                    FieldValue.arrayRemove(
                                        [equipment.toMap()]));
                              });
                            });

                        try {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(res
                                  ? 'Deleted Successfully!'
                                  : 'An error occurred'),
                            ),
                          );
                        } catch (e) {}
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
