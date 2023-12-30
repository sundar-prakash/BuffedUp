// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:BuffedUp/const/DataTypes/GymMember.dart';
import 'package:BuffedUp/src/screens/members/memberweightscreen.dart';
import 'package:BuffedUp/src/services/firestore/memberdoc.dart';
import 'package:BuffedUp/src/widget/decoratedtextinput.dart';
import 'package:BuffedUp/src/widget/memberweightcard.dart';
import 'package:flutter/material.dart';

class MemberForm extends StatefulWidget {
  final GymMember? member;
  final String gymownerid;
  const MemberForm(this.gymownerid, {super.key, this.member});
  @override
  State<MemberForm> createState() => _MemberFormState();
}

class _MemberFormState extends State<MemberForm> {
  late TextEditingController _registerNumberController;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _genderController;
  late TextEditingController _addressController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _joinDateController;
  late TextEditingController _categoryController;
  late TextEditingController _amountController;
  late TextEditingController _paidOnController;
  late TextEditingController _validityController;

  @override
  void initState() {
    super.initState();
    _registerNumberController =
        TextEditingController(text: widget.member?.registerNumber.toString());
    _nameController = TextEditingController(text: widget.member?.name);
    _emailController = TextEditingController(text: widget.member?.email);
    _genderController = TextEditingController(text: widget.member?.gender);
    _addressController =
        TextEditingController(text: widget.member?.homeaddress);
    _phoneNumberController =
        TextEditingController(text: widget.member?.phoneNumber);
    _joinDateController = TextEditingController(
        text: widget.member != null
            ? DateTimetoString(widget.member!.joinDate)
            : "");
    _categoryController = TextEditingController(
        text: widget.member != null
            ? widget.member?.membershipType.category
            : "");
    _amountController = TextEditingController(
        text: widget.member?.membershipType.amount.toString());
    _paidOnController = TextEditingController(
        text: widget.member != null
            ? DateTimetoString(widget.member!.membershipType.paidon)
            : "");
    _validityController = TextEditingController(
        text: widget.member?.membershipType.validity.inDays.toString());
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
    _categoryController.dispose();
    _amountController.dispose();
    _paidOnController.dispose();
    _validityController.dispose();
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
                    if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                      return 'Enter a valid gender (only alphabets)';
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
                  widget.member?.weightData != null &&
                          widget.member!.weightData!.isNotEmpty
                      ? MemberWeightCard(widget.member!.weightData!.first,
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MemberWeightScreen(widget.member!))))
                      : TextButton(
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MemberWeightScreen(widget.member!))),
                          child: Text("Add Weight Data"))
                ],
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      GymMember newMember = GymMember(
                          name: _nameController.text,
                          gymownerid: widget.gymownerid,
                          joinDate: StringtoDateTime(_joinDateController.text),
                          registerNumber:
                              int.parse(_registerNumberController.text),
                          email: _emailController.text,
                          homeaddress: _addressController.text,
                          gender: _genderController.text,
                          profilePicture: '',

                          //profile pic
                          membershipType: MembershipType(
                              amount: int.parse(_amountController.text),
                              paidon: StringtoDateTime(_paidOnController.text),
                              category: _categoryController.text,
                              expiryDate: CalculateExpireDate(
                                  StringtoDateTime(_paidOnController.text),
                                  intToDays(
                                      int.parse(_validityController.text))),
                              validity: intToDays(
                                  int.parse(_validityController.text))),
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
        ? StringtoDateTime(controller.text)
        : DateTime.now(),
    firstDate: DateTime.now().subtract(const Duration(days: 365 * 10)),
    lastDate: DateTime.now().add(const Duration(days: 365)),
  );
  if (date != null) {
    final formattedDate = DateTimetoString(date);
    controller.text = formattedDate;
  }
}
