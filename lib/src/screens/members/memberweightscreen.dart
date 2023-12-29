import 'package:BuffedUp/const/Colors.dart';
import 'package:BuffedUp/const/DataTypes/GymMember.dart';
import 'package:BuffedUp/src/services/firestore/memberdoc.dart';
import 'package:BuffedUp/src/widget/decoratedtextinput.dart';
import 'package:BuffedUp/src/widget/memberweightcard.dart';
import 'package:BuffedUp/src/widget/searchindicator.dart';
import 'package:BuffedUp/src/widget/text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

class MemberWeightScreen extends StatelessWidget {
  final GymMember member;
  const MemberWeightScreen(this.member, {super.key});
  void _openNewWeightDialog(
      BuildContext context, List<MeasurementType>? weightDatas) {
    TextEditingController valueController = TextEditingController();
    TextEditingController dateController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('New Weight'),
          content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RoundedTextField(
                    controller: valueController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a value';
                      }

                      double? parsedValue = double.tryParse(value);
                      if (parsedValue == null) {
                        return 'Please enter a valid number';
                      }

                      if (parsedValue < 20 || parsedValue > 300) {
                        return 'Please enter a value between 20 and 300';
                      }

                      return null;
                    },
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Weight(kg)'),
                  ),
                  const SizedBox(height: 10),
                  RoundedTextField(
                    controller: dateController,
                    readOnly: true,
                    validator: (value) {
                      return null;
                    },
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );

                      if (pickedDate != null) {
                        dateController.text = DateTimetoString(pickedDate);
                      }
                    },
                    decoration: const InputDecoration(labelText: 'Date'),
                  ),
                ],
              )),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  double value = double.tryParse(valueController.text) ?? 0.0;
                  DateTime? recordedDate = dateController.text.isNotEmpty
                      ? StringtoDateTime(dateController.text)
                      : null;

                  MeasurementType newWeight = MeasurementType(
                    value: value,
                    recordedOn: recordedDate ?? DateTime.now(),
                  );
                  weightDatas!.add(newWeight);

                  weightDatas.sort((a, b) {
                    return (b.recordedOn.compareTo(a.recordedOn));
                  });

                  bool res;
                  List d = weightDatas.map((e) => e.toMap()).toList();

                  res = await updateMemberField(
                    member,
                    'weightData',
                    d,
                  );
                  try {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            res ? 'Saved Successfully!' : 'An error occurred'),
                      ),
                    );
                  } catch (e) {}
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<MeasurementType>? weightDatas = member.weightData;
    return Scaffold(
      floatingActionButton: Container(
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: IconButton(
            onPressed: () => _openNewWeightDialog(context, weightDatas),
            icon: const Icon(Icons.add)),
      ),
      appBar: AppBar(title: const Text("Weight Tracker")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('members')
            .where('gymownerid', isEqualTo: member.gymownerid)
            .where('registerNumber', isEqualTo: member.registerNumber)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            final QueryDocumentSnapshot<Map<String, dynamic>> memberDoc =
                snapshot.data!.docs.first;

            final Map<String, dynamic> memberDataMap = memberDoc.data();
            final GymMember MemberData = GymMember.fromMap(memberDataMap);
            weightDatas = MemberData.weightData;
            return weightDatas != null && weightDatas!.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: weightDatas!
                              .map((e) => TimelineTile(
                                    indicatorStyle: const IndicatorStyle(
                                      width: 20,
                                      color: secondaryColor,
                                    ),
                                    alignment: TimelineAlign.start,
                                    endChild: MemberWeightCard(e, onDelete:
                                        (MeasurementType weightToDelete) async {
                                      final res = await updateMemberField(
                                          MemberData,
                                          'weightData',
                                          FieldValue.arrayRemove(
                                              [weightToDelete.toMap()]));
                                      try {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(res
                                                ? 'Deleted Successfully!'
                                                : 'An error occurred'),
                                          ),
                                        );
                                      } catch (e) {}
                                    }),
                                  ))
                              .toList(),
                        ),
                      ),
                    ]),
                  )
                : const Center(child: MediumText("No Data Found!"));
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
