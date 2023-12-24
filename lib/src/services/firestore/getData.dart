import 'package:BuffedUp/const/DataTypes/GymMember.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final _uid = FirebaseAuth.instance.currentUser!.uid;
final _docRef = _firestore.collection('gymowner').doc(_uid);
Future<List<GymMember>> fetchAllMembers() async {
  final docSnapshot = await _docRef.get();

  if (docSnapshot.exists) {
    final memberData = docSnapshot.get('members') as List?;
    if (memberData != null) {
      return memberData
          .map((memberMap) => GymMember.fromMap(memberMap))
          .toList();
    } else {
      return [];
    }
  } else {
    throw Exception('User document not found');
  }
}

