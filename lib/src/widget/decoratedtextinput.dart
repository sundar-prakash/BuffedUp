import 'package:flutter/material.dart';

class RoundedTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final InputDecoration decoration;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final bool readOnly;
  final VoidCallback? onTap;
  final bool isMultiline;

  RoundedTextField({
    Key? key,
    required this.controller,
    this.focusNode,
    this.readOnly = false,
    this.onTap,
    this.isMultiline = false,
    this.decoration = const InputDecoration(),
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.onChanged,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: TextFormField(
          controller: controller,
          focusNode: focusNode,
          readOnly: readOnly,
          onTap: onTap,
          maxLines: isMultiline ? null : 1,
          decoration: decoration.copyWith(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          keyboardType: isMultiline ? TextInputType.multiline : keyboardType,
          onChanged: onChanged,
          validator: validator,
        ));
  }
}
