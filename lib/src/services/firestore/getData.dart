import 'package:BuffedUp/const/DataTypes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<List<GymMember>> fetchMembers() async {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final docRef = _firestore.collection('users').doc(uid);
  final docSnapshot = await docRef.get();

  if (docSnapshot.exists) {
    final memberData = docSnapshot.get('members') as List?;
    if (memberData != null) {
      return memberData.map((memberMap) => GymMember.fromJson(memberMap)).toList();
    } else {
      return [];
    }
  } else {
    // User document not found
    throw Exception('User document not found');
  }
}
