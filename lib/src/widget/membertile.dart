import 'package:BuffedUp/const/DataTypes/GymMember.dart';
import 'package:BuffedUp/src/screens/members/editmemberscreen.dart';
import 'package:BuffedUp/src/screens/members/viewmemberscreen.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MemberTile extends StatelessWidget {
  String gymName;
  GymMember member;
  MemberTile(this.gymName, this.member, {super.key});

  @override
  Widget build(BuildContext context) {
    final MembershipOver = isMembershipExpired(
        member.membershipType.paidon, member.membershipType.validity);
    return Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          border: Border.all(
              width: 2.0,
              color: MembershipOver ? Colors.red[300]! : Colors.green[300]!),
          color: MembershipOver ? Colors.red[100] : Colors.green[100],
          borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ViewMemberScreen(gymName, member))),
        leading: CircleAvatar(child: Text(member.name.substring(0, 1))),
        title: Text(member.name),
        subtitle: Text("Register Number: ${member.registerNumber.toString()}"),
        trailing: IconButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditMemberScreen(gymName, member))),
            icon: const Icon(Icons.edit)),
      ),
    );
  }
}

bool isMembershipExpired(DateTime paidon, Duration validity) {
  final DateTime expiryDate = paidon.add(validity);
  final DateTime currentDate = DateTime.now();
  return currentDate.isAfter(expiryDate);
}
//shared prefrence to save filter