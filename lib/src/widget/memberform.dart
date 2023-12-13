// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:BuffedUp/const/DataTypes.dart';
import 'package:BuffedUp/src/widget/decoratedtextinput.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MemberForm extends StatefulWidget {
  final GymMember? member;
  const MemberForm({super.key, this.member});
  @override
  State<MemberForm> createState() => _MemberFormState();
}

class _MemberFormState extends State<MemberForm> {
  @override
  Widget build(BuildContext context) {
    final _registerNumberController =
        TextEditingController(text: widget.member?.reqisterNumber.toString());
    final _nameController = TextEditingController(text: widget.member?.name);
    final _emailController = TextEditingController(text: widget.member?.email);
    final _phoneNumberController =
        TextEditingController(text: widget.member?.phoneNumber);
    final _joinDateController = TextEditingController(
        text: widget.member != null ? yearFormat(widget.member!.joinDate) : "");
    final _amountController = TextEditingController(
        text: widget.member?.membershipType.amount.toString());
    final _paidOnController = TextEditingController(
        text: widget.member != null
            ? yearFormat(widget.member!.membershipType.paidon)
            : "");
    final _validityController = TextEditingController(
        text: widget.member?.membershipType.validity.inDays.toString());

    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RoundedTextField(
            controller: _registerNumberController,
            readOnly: true,
            decoration: const InputDecoration(labelText: 'Register Number'),
          ),
          RoundedTextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Name'),
            validator: (value) =>
                (value?.isEmpty ?? true) ? 'Name is required' : null,
          ),
          RoundedTextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          RoundedTextField(
            controller: _phoneNumberController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(labelText: 'Phone Number'),
          ),
          RoundedTextField(
              controller: _joinDateController,
              readOnly: true, // User can't directly edit the date
              decoration: const InputDecoration(labelText: 'Date'),
              onTap: () => datePicker(context, _joinDateController)),
          Column(
            children: [
              RoundedTextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Amount'),
              ),
              RoundedTextField(
                  controller: _paidOnController,
                  readOnly: true, // User can't directly edit the date
                  decoration: const InputDecoration(labelText: 'Paid On'),
                  onTap: () => datePicker(context, _paidOnController)),
              RoundedTextField(
                controller: _validityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Validity (Days)'),
              ),
            ],
          )
        ],
      ),
    );
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
