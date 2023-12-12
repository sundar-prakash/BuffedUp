import 'package:flutter/material.dart';

class editmemberscreen extends StatelessWidget {
  int reg;
  editmemberscreen(this.reg, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit $reg"),
      ),
    );
  }
}
