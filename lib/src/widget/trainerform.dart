// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:BuffedUp/const/DataTypes/Trainers.dart';
import 'package:BuffedUp/src/services/firestore/ownerdoc.dart';
import 'package:BuffedUp/src/widget/decoratedtextinput.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TrainerForm extends StatefulWidget {
  final Trainer? trainer;
  const TrainerForm({super.key, this.trainer});
  @override
  State<TrainerForm> createState() => _TrainerFormState();
}

class _TrainerFormState extends State<TrainerForm> {
  late TextEditingController _registerNumberController;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _genderController;
  late TextEditingController _addressController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _joinDateController;

  @override
  void initState() {
    super.initState();
    _registerNumberController =
        TextEditingController(text: widget.trainer?.registerNumber.toString());
    _nameController = TextEditingController(text: widget.trainer?.name);
    _emailController = TextEditingController(text: widget.trainer?.email);
    _genderController = TextEditingController(text: widget.trainer?.gender);
    _addressController = TextEditingController(text: widget.trainer?.homeaddress);
    _phoneNumberController = TextEditingController(text: widget.trainer?.phoneNumber);
    _joinDateController = TextEditingController(
        text: widget.trainer != null ? yearFormat(widget.trainer!.joinDate) : "");
  }
  @override
  void dispose() {
    _registerNumberController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _genderController.dispose();
    _addressController.dispose();
    _phoneNumberController.dispose();
    _joinDateController.dispose();
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
                controller: _registerNumberController,
                decoration: const InputDecoration(labelText: 'Register Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Register Number cannot be empty';
                  } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return 'Register Number must contain only numbers';
                  }
                  return null; // Return null for no error
                },
              ),
              RoundedTextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name is required';
                  } else if (!RegExp(r'^[a-zA-Z. ]+$').hasMatch(value)) {
                    return 'Name should contain only alphabets and dots';
                  } else if (value.startsWith('.') || value.endsWith('.')) {
                    return 'Name should not start or end with a dot';
                  }
                  return null; // Return null for no error
                },
              ),
              RoundedTextField(
                controller: _addressController,
                keyboardType: TextInputType.emailAddress,
                decoration:
                    const InputDecoration(labelText: 'Address(optional)'),
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    if (value.isNotEmpty) {
                      if (!RegExp(r'^[a-zA-Z0-9\s,.\\\/-]+$').hasMatch(value)) {
                        return 'Enter a valid address without fancy symbols';
                      }
                    }
                  }
                  return null;
                },
              ),
              RoundedTextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email(optional)'),
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'Enter a valid email';
                    }
                  }
                  return null; // Return null for no error or empty email
                },
              ),
              RoundedTextField(
                controller: _genderController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Gender'),
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    if (!RegExp(r'^[a-zA-Z]{1,15}$').hasMatch(value)) {
                      return 'Enter a valid gender with a maximum of 15 alphabets';
                    }
                  }
                  return null;
                },
              ),
              RoundedTextField(
                controller: _phoneNumberController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Phone number is required';
                  } else if (value.length > 20) {
                    return 'Phone number should not exceed 20 characters';
                  } else if (value.length < 10) {
                    return 'Phone number must be atleast 10 characters';
                  } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return 'Enter a valid phone number';
                  }
                  return null; // Return null for no error
                },
              ),
              RoundedTextField(
                  controller: _joinDateController,
                  readOnly: true, // User can't directly edit the date
                  decoration: const InputDecoration(labelText: 'Date'),
                  validator: (value) {
                    if (value != null && value.isEmpty) {
                      return 'Join Date should not be empty';
                    }
                    return null; // Return null for no error
                  },
                  onTap: () => datePicker(context, _joinDateController)),
              ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      Trainer newtrainer = Trainer(
                          name: _nameController.text,
                          joinDate: DateTime.parse(_joinDateController.text),
                          registerNumber:
                              int.parse(_registerNumberController.text),
                          email: _emailController.text,
                          homeaddress: _addressController.text,
                          gender: _genderController.text,
                          profilePicture: '',
                          //profile pic

                          phoneNumber: _phoneNumberController.text);
                      bool res;
                      if (widget.trainer != null) {
                        List trainersField = await FetchField('trainers');
                        List<Trainer> trainers = trainersField
                            .map((e) => Trainer.fromMap(e))
                            .toList();
                        final filteredtrainers = trainers
                            .where((e) => e.name == widget.trainer!.name)
                            .toList();
                        filteredtrainers[0] = newtrainer;
                        List<Map<String, dynamic>> updatedTrainers =
                            filteredtrainers.map((e) => e.toMap()).toList();
                        res = await updateOwner(
                          'trainers',
                          updatedTrainers,
                        );
                      } else {
                        res = await updateOwner(
                          'trainers',
                          FieldValue.arrayUnion([newtrainer.toMap()]),
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

Future<void> datePicker(
    BuildContext context, TextEditingController controller) async {
  final date = await showDatePicker(
    context: context,
    initialDate: controller.text.isNotEmpty
        ? DateTime.parse(controller.text)
        : DateTime.now(),
    firstDate: DateTime.now().subtract(const Duration(days: 365 * 10)),
    lastDate: DateTime.now().add(const Duration(days: 365)),
  );
  if (date != null) {
    final formattedDate = DateFormat('yyyy-MM-dd').format(date);
    controller.text = formattedDate;
  }
}

String yearFormat(DateTime d) {
  return DateFormat('yyyy-MM-dd').format(d);
}
