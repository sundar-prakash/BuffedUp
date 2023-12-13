import 'package:BuffedUp/const/DataTypes.dart';
import 'package:BuffedUp/src/widget/memberform.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class editmemberscreen extends StatelessWidget {
  int reg;
  editmemberscreen(this.reg, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit $reg"),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.check,
              ))
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: MemberForm(member: members[0]),
      ),
    );
  }
}
