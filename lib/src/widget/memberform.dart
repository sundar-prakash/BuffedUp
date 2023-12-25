// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:BuffedUp/const/DataTypes/GymMember.dart';
import 'package:BuffedUp/src/services/firestore/memberdoc.dart';
import 'package:BuffedUp/src/widget/decoratedtextinput.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MemberForm extends StatefulWidget {
  final GymMember? member;
  final String gymownerid;
  const MemberForm(this.gymownerid, {super.key, this.member});
  @override
  State<MemberForm> createState() => _MemberFormState();
}

class _MemberFormState extends State<MemberForm> {
  @override
  Widget build(BuildContext context) {
    final _registerNumberController =
        TextEditingController(text: widget.member?.registerNumber.toString());
    final _nameController = TextEditingController(text: widget.member?.name);
    final _emailController = TextEditingController(text: widget.member?.email);
    final _genderController =
        TextEditingController(text: widget.member?.gender);
    final _addressController =
        TextEditingController(text: widget.member?.homeaddress);
    final _phoneNumberController =
        TextEditingController(text: widget.member?.phoneNumber);
    final _joinDateController = TextEditingController(
        text: widget.member != null ? yearFormat(widget.member!.joinDate) : "");
    final _categoryController = TextEditingController(
        text: widget.member != null
            ? widget.member?.membershipType.category
            : "");
    final _amountController = TextEditingController(
        text: widget.member?.membershipType.amount.toString());
    final _paidOnController = TextEditingController(
        text: widget.member != null
            ? yearFormat(widget.member!.membershipType.paidon)
            : "");
    final _validityController = TextEditingController(
        text: widget.member?.membershipType.validity.inDays.toString());

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
                  } else if (RegExp(r'^[a-zA-Z]+(?: [a-zA-Z]+)*$')
                      .hasMatch(value)) {
                    return 'Name should not contain special characters or numbers';
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
                decoration:
                    const InputDecoration(labelText: 'Gender(optional)'),
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    if (value.length > 15) {
                      return 'Maximum 15 characters allowed';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'Enter a valid gender';
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
              Column(
                children: [
                  RoundedTextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Amount'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Amount is required';
                      } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                        return 'Enter a valid amount (numbers only)';
                      }
                      return null; // Return null for no error
                    },
                  ),
                  RoundedTextField(
                      controller: _paidOnController,
                      readOnly: true,
                      decoration: const InputDecoration(labelText: 'Paid On'),
                      validator: (value) {
                        if (value != null && value.isEmpty) {
                          return 'Paid On should not be empty';
                        }
                        return null;
                      },
                      onTap: () => datePicker(context, _paidOnController)),
                  RoundedTextField(
                    controller: _categoryController,
                    decoration:
                        const InputDecoration(labelText: 'Category(optional)'),
                    validator: (value) {
                      if (value != null && value.length > 50) {
                        return 'Category should not exceed 50 characters';
                      } else if (value != null &&
                          !RegExp(r'^[a-zA-Z0-9 ]*$').hasMatch(value)) {
                        return 'Category can only contain letters and numbers';
                      }
                      return null;
                    },
                  ),
                  RoundedTextField(
                    controller: _validityController,
                    keyboardType: TextInputType.number,
                    decoration:
                        const InputDecoration(labelText: 'Validity (Days)'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Validity is required';
                      } else if (!RegExp(r'^[0-9]{1,4}$').hasMatch(value)) {
                        return 'Enter a valid validity (up to 4 numbers)';
                      }
                      return null; // Return null for no error
                    },
                  ),
                ],
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      GymMember newMember = GymMember(
                          name: _nameController.text,
                          gymownerid: widget.gymownerid,
                          joinDate: DateTime.parse(_joinDateController.text),
                          registerNumber:
                              int.parse(_registerNumberController.text),
                          email: _emailController.text,
                          homeaddress: _addressController.text,
                          gender: _genderController.text,
                          profilePicture: '',
                          //profile pic
                          membershipType: MembershipType(
                              amount: int.parse(_amountController.text),
                              paidon: DateTime.parse(_paidOnController.text),
                              category: _categoryController.text,
                              validity: Duration(
                                  days: int.parse(_validityController.text))),
                          phoneNumber: _phoneNumberController.text);
                      bool res;
                      if (widget.member != null) {
                        res = await updateMember(newMember);
                      } else {
                        res = await createMemberDocument(newMember);
                      }
                      final scaffoldContext = context;
                      try {
                        ScaffoldMessenger.of(scaffoldContext).showSnackBar(
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
