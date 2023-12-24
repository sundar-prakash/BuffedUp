import 'package:BuffedUp/const/DataTypes/GymMember.dart';
import 'package:BuffedUp/src/widget/memberform.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class editmemberscreen extends StatelessWidget {
  String gymownerid;
  GymMember member;
  
  editmemberscreen( this.gymownerid,this.member, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit ${member.registerNumber}"),
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: MemberForm(gymownerid,member: member),
      ),
    );
  }
}
