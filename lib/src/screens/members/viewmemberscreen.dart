import 'package:flutter/material.dart';

class viewmemberscreen extends StatelessWidget {
  int reg;
  viewmemberscreen(this.reg, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$reg"),
      ),
    );
  }
}
