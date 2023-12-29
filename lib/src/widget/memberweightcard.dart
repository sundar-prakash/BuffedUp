import 'package:BuffedUp/const/Colors.dart';
import 'package:BuffedUp/const/DataTypes/GymMember.dart';
import 'package:BuffedUp/src/widget/Dialogs.dart';
import 'package:flutter/material.dart';

class MemberWeightCard extends StatelessWidget {
  final MeasurementType weight;
  final Function? onTap;
  final Function(MeasurementType weight)? onDelete;
  const MemberWeightCard(
    this.weight, {
    this.onTap,
    this.onDelete,
    Key? key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3, // Add elevation for shadow
      shadowColor: Colors.grey, // Shadow color
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(5),
        child: ListTile(
          contentPadding: const EdgeInsets.all(15),
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey[900],
            child: const Icon(
              Icons.monitor_weight_outlined,
              size: 40,
              color: accentColor,
            ),
          ),
          onTap: () => onTap?.call(),
          trailing: onDelete != null
              ? IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return DeleteConfirmationDialog(
                            onConfirm: () {
                              onDelete?.call(weight);
                            },
                          );
                        });
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.redAccent,
                  ))
              : null,
          title: Text(
            weight.value.toString(),
            style: const TextStyle(
                color: secondaryColor, fontWeight: FontWeight.w700),
          ),
          subtitle: Text(
            DateTimetoString(weight.recordedOn),
          ),
        ),
      ),
    );
  }
}
