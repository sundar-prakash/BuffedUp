import 'package:BuffedUp/const/DataTypes/GymMember.dart';
import 'package:BuffedUp/src/services/firestore/userdoc.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:intl/intl.dart';

class FirestoreImportScreen extends StatelessWidget {
  final String jsonFilePath = 'asset/dj.json';
  @override
  Widget build(BuildContext context) {
    Future<void> _importDataToFirestore() async {
      try {
        String jsonContent =
            await DefaultAssetBundle.of(context).loadString(jsonFilePath);
        List<dynamic> jsonData = json.decode(jsonContent);

        List<GymMember> gymMembers = jsonData.map((memberData) {
          String paidon =
              memberData['paidon'] ?? ''; // Using empty string if null
          String joinDate =
              memberData['joinDate'] ?? ''; // Using empty string if null

          DateFormat dateFormat = DateFormat('dd-MM-yyyy');
          DateTime paidonDateTime =
              paidon.isNotEmpty ? dateFormat.parse(paidon) : DateTime.now();
          DateTime joinDateDateTime =
              joinDate.isNotEmpty ? dateFormat.parse(joinDate) : DateTime.now();

          MembershipType mt = MembershipType(
            amount: memberData['amount'] ?? 0,
            paidon: paidonDateTime,
            category: memberData['category'],
            validity: Duration(days: memberData['validity'] ?? 0),
          );

          return GymMember(
            name:
                memberData['name'] != null ? memberData['name'].toString() : "",
            joinDate: joinDateDateTime,
            email: "",
            profilePicture: "",
            homeaddress: memberData['homeaddress'] != null
                ? memberData['homeaddress'].toString()
                : "",
            registerNumber: memberData['registerNumber'] ?? 0,
            membershipType: mt,
            phoneNumber: memberData['phoneNumber'] != null
                ? memberData['phoneNumber'].toString()
                : "",
          );
        }).toList();

        print("Started");
        for (var member in gymMembers) {
          await uploadMember(member);
        }

        print('Data imported successfully!');
      } catch (e) {
        print('Error importing data: $e');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Firestore JSON Import'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _importDataToFirestore,
          child: Text('Import Data to Firestore'),
        ),
      ),
    );
  }
}
