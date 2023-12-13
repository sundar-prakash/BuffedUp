import 'package:BuffedUp/const/DataTypes.dart';
import 'package:BuffedUp/src/screens/members/editmemberscreen.dart';
import 'package:BuffedUp/src/widget/memberform.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class viewmemberscreen extends StatelessWidget {
  int reg;
  viewmemberscreen(this.reg, {super.key});
  final member = members[0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("$reg"),
        ),
        body: Card(
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
                      backgroundImage: member.profilePicture != null
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
                            'Registration Number: ${member.reqisterNumber}',
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
                  leading: const Icon(Icons.email),
                  title: Text(member.email ?? 'No Email'),
                ),
                ListTile(
                  leading: const Icon(Icons.phone),
                  title: Text(member.phoneNumber),
                ),
                ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: Text('Join Date: ${yearFormat(member.joinDate)}'),
                ),
                ListTile(
                  leading: const Icon(Icons.monetization_on),
                  title: Text(
                    'Membership Details: ${member.membershipType.amount} - ${member.membershipType.validity.inDays} days',
                  ),
                  subtitle: Text(
                    'Paid On: ${yearFormat(member.membershipType.paidon)}',
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        // Implement delete logic here
                      },
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.delete),
                          SizedBox(width: 8),
                          Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => editmemberscreen(reg)));
                        },
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.edit),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        )),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
