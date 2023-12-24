import 'package:flutter/material.dart';

class CustomRadioButton extends StatelessWidget {
  final String text;
  final int value;
  final int groupValue;
  final ValueChanged<int> onChanged;

  const CustomRadioButton({
    Key? key,
    required this.text,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: OutlinedButton(
          onPressed: () {
            onChanged(value);
          },
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            side: BorderSide(
              color: (groupValue == value) ? Colors.green : Colors.black,
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: (groupValue == value) ? Colors.green : Colors.black,
            ),
          ),
        ));
  }
}
