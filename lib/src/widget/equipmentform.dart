// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:BuffedUp/const/DataTypes/Equipment.dart';
import 'package:BuffedUp/src/services/firestore/ownerdoc.dart';
import 'package:BuffedUp/src/widget/decoratedtextinput.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EquipmentForm extends StatefulWidget {
  final EquipmentType? equipment;
  const EquipmentForm({super.key, this.equipment});
  @override
  State<EquipmentForm> createState() => _EquipmentFormState();
}

class _EquipmentFormState extends State<EquipmentForm> {
   late TextEditingController _countController;
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _countController =
        TextEditingController(text: widget.equipment?.count.toString());
    _nameController = TextEditingController(text: widget.equipment?.name);
    _descriptionController =
        TextEditingController(text: widget.equipment?.description);
  }

  @override
  void dispose() {
    _countController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final _formKey = GlobalKey<FormState>();

    return Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RoundedTextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Equipment Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'EquipmentName is required';
                  } else if (!RegExp(r'^[a-zA-Z0-9]+(?: [a-zA-Z0-9]+)*$')
                      .hasMatch(value)) {
                    return 'EquipmentName should not contain special characters';
                  } else if (value.startsWith('.') || value.endsWith('.')) {
                    return 'Equipment Name should not start or end with a dot';
                  }
                  return null;
                },
              ),
              RoundedTextField(
                controller: _countController,
                decoration: const InputDecoration(labelText: 'Count'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Count cannot be empty';
                  } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return 'Count must contain only numbers';
                  }
                  return null;
                },
              ),
              RoundedTextField(
                controller: _descriptionController,
                keyboardType: TextInputType.emailAddress,
                decoration:
                    const InputDecoration(labelText: 'Description(optional)'),
                validator: (value) {
                  if (value != null && value.length > 40) {
                    return 'Description should not exceed 40 characters';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      EquipmentType newEquipment = EquipmentType(
                        name: _nameController.text,
                        count: int.tryParse(_countController.text) ?? 1,
                        description: _descriptionController.text,
                      );
                      bool res;
                      if (widget.equipment != null) {
                        final EquipmentFieldFetch = await FetchField('equipments');
                        List<EquipmentType> equipments = EquipmentFieldFetch.map((e) => EquipmentType.fromMap(e)).toList();
                        final filteredEquipments = equipments
                            .where((e) => e.name == widget.equipment!.name)
                            .toList();
                        filteredEquipments[0].count =
                            int.tryParse(_countController.text) ?? 1;
                        filteredEquipments[0].name = _nameController.text;
                        filteredEquipments[0].description =
                            _descriptionController.text;
                        List<Map<String, dynamic>> updatedEquipments =
                            filteredEquipments.map((e) => e.toMap()).toList();
                        res = await updateOwner(
                          'equipments',
                          updatedEquipments,
                        );
                      } else {
                        res = await updateOwner(
                          'equipments',
                          FieldValue.arrayUnion([newEquipment.toMap()]),
                        );
                      }

                      try {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(res
                                ? 'Saved Successfully!'
                                : 'An error occurred'),
                          ),
                        );
                      } catch (e) {}
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Save"))
            ],
          ),
        ));
  }
}
