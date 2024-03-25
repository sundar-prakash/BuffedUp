import 'package:BuffedUp/const/DataTypes/GymMember.dart';
import 'package:BuffedUp/src/screens/members/editmemberscreen.dart';
import 'package:BuffedUp/src/screens/members/memberweightscreen.dart';
import 'package:BuffedUp/src/services/firestore/memberdoc.dart';
import 'package:BuffedUp/src/widget/Dialogs.dart';
import 'package:BuffedUp/src/widget/membertile.dart';
import 'package:BuffedUp/src/widget/memberweightcard.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ViewMemberScreen extends StatelessWidget {
  String gymownerid;
  GymMember member;
  ViewMemberScreen(this.gymownerid, this.member, {super.key});

  @override
  Widget build(BuildContext context) {
    bool isNotActive = isMembershipExpired(
        member.membershipType.paidon, member.membershipType.validity);
    return Scaffold(
        appBar: AppBar(
          title: Text("${member.registerNumber}"),
        ),
        body: SingleChildScrollView(
            child: Card(
          elevation: 4,
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: member.profilePicture != null &&
                              member.profilePicture!.isNotEmpty
                          ? NetworkImage(member.profilePicture!)
                          : null,
                      radius: 40,
                      child: Text(member.name.substring(0, 1)),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            member.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Registration Number: ${member.registerNumber}',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.home),
                  title: Text(member.homeaddress != ""
                      ? member.homeaddress ?? 'No Address'
                      : 'No Address'),
                ),
                ListTile(
                  leading: const Icon(Icons.email),
                  title: Text(member.email != ""
                      ? member.email ?? 'No Email'
                      : 'No Email'),
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(member.gender != ""
                      ? member.gender ?? 'No Gender'
                      : 'No Gender'),
                ),
                ListTile(
                  leading: const Icon(Icons.phone),
                  title: Text(member.phoneNumber),
                ),
                ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title:
                      Text('Join Date: ${DateTimetoString(member.joinDate)}'),
                ),
                ListTile(
                  leading: const Icon(Icons.monetization_on),
                  title: Text(
                    'Membership Details: ${member.membershipType.amount} - ${member.membershipType.validity.inDays} days',
                  ),
                  subtitle: Text(
                    'Paid On: ${DateTimetoString(member.membershipType.paidon)}',
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.calendar_month_outlined),
                  title: Text(
                      'Expires on : ${DateTimetoString(member.membershipType.expiryDate)}'),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.dashboard,
                  ),
                  title: Text("${member.membershipType.category}"),
                ),
                ListTile(
                  leading: Icon(
                    isNotActive ? Icons.close : Icons.check,
                    color: isNotActive ? Colors.red : Colors.green,
                  ),
                  title: Text(
                    isNotActive ? "Expired" : "Active",
                  ),
                ),
                if (member.weightData != null && member.weightData!.isNotEmpty)
                  MemberWeightCard(member.weightData!.first,
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MemberWeightScreen(member)))),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () async {
                        late bool res;
                        await showDialog(
                            context: context,
                            builder: (_) {
                              return DeleteConfirmationDialog(
                                  onConfirm: () async {
                                res = await deleteMemberDocument(
                                    member.gymownerid, member.registerNumber);
                              });
                            });
                        Navigator.pop(context);

                        try {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(res
                                  ? 'Deleted Successfully!'
                                  : 'An error occurred'),
                            ),
                          );
                        } catch (e) {}
                      },
                      icon: const Icon(Icons.delete),
                      label: const Text("Delete"),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    EditMemberScreen(gymownerid, member)));
                      },
                      label: const Text('Edit'),
                      icon: const Icon(Icons.edit),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )));
  }
}
