import 'package:BuffedUp/const/DataTypes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
Future<void> createUserDocument(String uid) async {
  final docRef = _firestore.collection('users').doc(uid);

  final data = {
    'uid': uid,
    'name': '',
    'members': [],
    'equipments': null,
    'expenses': null
  };

  await docRef.set(data);
}
//TODO - implement single member delte instead of whoel memeber upload

Future<bool> uploadMember(GymMember member) async {
  final docId = FirebaseAuth.instance.currentUser!.uid;

  final data = {
    'name': member.name,
    'email': member.email,
    'joinDate': member.joinDate,
    'membershipType': {
      'amount': member.membershipType.amount,
      'paidon': member.membershipType.paidon,
      'validity': member.membershipType.validity.inDays,
    },
    'phoneNumber': member.phoneNumber,
    'registerNumber': member.registerNumber,
  };

  final docRef = _firestore.collection('users').doc(docId);

  final docSnapshot = await docRef.get();
  if (docSnapshot.exists) {
    final List<dynamic> members = docSnapshot.data()!['members'] ?? [];

    final index =
        members.indexWhere((m) => m['registerNumber'] == member.registerNumber);

    if (index != -1) {
      members[index] = data;
    } else {
      members.add(data);
    }

    await docRef.update({
      'members': members,
    });

    return true;
  }

  return false;
}

Future<bool> deleteMember(int registerNumber) async {
  final docId = FirebaseAuth.instance.currentUser!.uid;
  final docRef = _firestore.collection('users').doc(docId);

  final docSnapshot = await docRef.get();
  if (docSnapshot.exists) {
    final List<dynamic> members = docSnapshot.data()!['members'] ?? [];

    final updatedMembers =
        members.where((m) => m['registerNumber'] != registerNumber).toList();

    await docRef.update({
      'members': updatedMembers,
    });

    return true;
  }

  return false;
}
