import 'package:fitrack/src/screens/members/editmemberscreen.dart';
import 'package:fitrack/src/screens/members/viewmemberscreen.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class membertile extends StatelessWidget {
  String name;
  String? avatar;
  int reg;
  membertile(this.name, this.reg, {this.avatar, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => viewmemberscreen(reg))),
        leading: CircleAvatar(child: Text(name.substring(0, 1))),
        title: Text(name),
        subtitle: Text("Register Number: ${reg.toString()}"),
        trailing: IconButton(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => editmemberscreen(reg))),
            icon: Icon(Icons.edit)),
      ),
    );
  }
}
