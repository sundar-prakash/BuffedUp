import 'package:BuffedUp/const/DataTypes/GymMember.dart';
import 'package:BuffedUp/src/services/firestore/memberdoc.dart';
import 'package:BuffedUp/src/services/firestore/ownerdoc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:intl/intl.dart';

class FirestoreImportScreen extends StatelessWidget {
  final String jsonFilePath = 'asset/dj.json';
  final _ownerid = '2Jt614Fn7cfIcf7aR5U2DTrGUyq1';

  const FirestoreImportScreen({super.key});
  @override
  Widget build(BuildContext context) {
    Future<void> _updateExpireDatesForMembers() async {
      CollectionReference membersRef =
          FirebaseFirestore.instance.collection('members');

      QuerySnapshot membersSnapshot = await membersRef.get();
      List docIds = [];
      print("Started");
      for (QueryDocumentSnapshot memberDoc in membersSnapshot.docs) {
        // DateTime paidOn =
        //     StringtoDateTime(memberDoc['membershipType']['paidon'] as String);
        // DateTime joindate = StringtoDateTime(memberDoc['joinDate'] as String);
        // Duration validityInDays =
        //     intToDays(memberDoc['membershipType']['validity'] as int);

        // DateTime expirationDate = paidOn.add(validityInDays);
        // await memberDoc.reference.update({
        //   'membershiptype.paidon': paidOn,
        //   'membershiptype.expirydate': expirationDate,
        //   'joinDate': joindate,
        // });
        docIds.add(memberDoc.id);
      }
      await updateOwner('members', docIds);

      print("completed");
    }

    Future<void> _updateMemberInOwner() async {
      try {
        print("Started");
        final querySnapshot = await FirebaseFirestore.instance
            .collection('members')
            .where('gymownerid', isEqualTo: _ownerid)
            .get();

        final memberIds = querySnapshot.docs.map((doc) => doc.id).toList();

        await updateOwner('members', FieldValue.arrayUnion(memberIds));
        print("Imported Successfully");
      } catch (e) {
        print('Error updating member in owner: $e');
        // Handle the error
      }
    }

    Future<void> _importDataToFirestore() async {
      try {
        String jsonContent =
            await DefaultAssetBundle.of(context).loadString(jsonFilePath);
        List<dynamic> jsonData = json.decode(jsonContent);

        List<GymMember> gymMembers = jsonData.map((memberData) {
          String paidon = memberData['paidon'] ?? '';
          String joinDate = memberData['joinDate'] ?? '';

          DateFormat dateFormat = DateFormat('dd-MM-yyyy');
          DateTime paidonDateTime =
              paidon.isNotEmpty ? dateFormat.parse(paidon) : DateTime.now();
          DateTime joinDateDateTime =
              joinDate.isNotEmpty ? dateFormat.parse(joinDate) : DateTime.now();

          MembershipType mt = MembershipType(
            expiryDate: CalculateExpireDate(
                paidonDateTime, intToDays(memberData['validity'] ?? 0)),
            amount: memberData['amount'] ?? 0,
            paidon: paidonDateTime,
            category: memberData['category'],
            validity: intToDays(memberData['validity'] ?? 0),
          );

          return GymMember(
            name: memberData['name'] != null
                ? memberData['name'].toString().toLowerCase()
                : "",
            joinDate: joinDateDateTime,
            email: "",
            profilePicture: "",
            homeaddress: memberData['homeaddress'] != null
                ? memberData['homeaddress'].toString()
                : "",
            gymownerid: _ownerid,
            registerNumber: memberData['registerNumber'] ?? 0,
            membershipType: mt,
            phoneNumber: memberData['phoneNumber'] != null
                ? memberData['phoneNumber'].toString()
                : "",
          );
        }).toList();

        print("Started");
        try {
          List<String> docIds = [];

          for (var member in gymMembers) {
            final docId = await createMemberDocument(member);
            if (docId != null) {
              docIds.add(docId);
            }
          }

          await updateOwner('members', docIds);
        } catch (e) {
          rethrow;
        }

        print('Data imported successfully!');
      } catch (e) {
        print('Error importing data: $e');
      }
    }

  



    return Scaffold(
      appBar: AppBar(
        title: const Text('Firestore JSON Import'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: null,
          child: const Text('Import Data to Firestore'),
        ),
      ),
    );
  }
}
