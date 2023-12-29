import 'package:BuffedUp/const/DataTypes/Trainers.dart';
import 'package:BuffedUp/src/screens/trainers/EditTrainer.dart';
import 'package:BuffedUp/src/services/firestore/ownerdoc.dart';
import 'package:BuffedUp/src/widget/Dialogs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TrainerCard extends StatelessWidget {
  final Trainer trainer;

  const TrainerCard(this.trainer, {super.key});

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
            "asset/trainerplaceholder.jpg",
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
                Row(
                  children: [
                    Text(
                      trainer.name,
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.grey[800],
                      ),
                    ),
                    Text(
                      " - ",
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.grey[800],
                      ),
                    ),
                    Text(
                      trainer.gender,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  "Phone: ${trainer.phoneNumber}",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 10),
                if (trainer.homeaddress != null &&
                    trainer.homeaddress!.isNotEmpty)
                  Text(
                    "${trainer.homeaddress}",
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
                                  EditTrainerScreen(trainer))),
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
                                res = await updateOwner('trainers',
                                    FieldValue.arrayRemove([trainer.toMap()]));
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
