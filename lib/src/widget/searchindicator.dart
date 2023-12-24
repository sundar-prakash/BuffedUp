// ignore_for_file: must_be_immutable

import 'package:BuffedUp/src/widget/text.dart';
import 'package:flutter/cupertino.dart';

class SearchingIndicator extends StatelessWidget {
  String? text;
  double radius;
  SearchingIndicator({this.text, this.radius = 20, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      CupertinoActivityIndicator(
        radius: radius,
      ),
      if (text != null) SmallText("$text")
    ]);
  }
}
