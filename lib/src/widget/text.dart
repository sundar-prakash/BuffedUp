import 'package:flutter/material.dart';

class BigText extends StatelessWidget {
  final String text;
  final bool bold;

  const BigText(
    this.text, {super.key, 
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 24.0,
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}

class MediumText extends StatelessWidget {
  final String text;
  final bool bold;

  const MediumText(
    this.text, {super.key, 
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 18.0,
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}

class SmallText extends StatelessWidget {
  final String text;
  final bool bold;

  const SmallText(
    this.text, {super.key, 
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14.0,
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}

class SubtitleText extends StatelessWidget {
  final String text;
  final bool bold;

  const SubtitleText(
    this.text, {super.key, 
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16.0,
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        color: Colors.grey[600],
      ),
    );
  }
}
