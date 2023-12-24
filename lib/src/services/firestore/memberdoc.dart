import 'package:BuffedUp/const/DataTypes/GymMember.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future createMemberDocument(GymMember member) async {
  try {
    final docRef = FirebaseFirestore.instance.collection('members').doc();
     await docRef.set(member.toMap());
    return docRef.id;
  } catch (e) {
    return false;
  }
}

Future<bool> updateMember(GymMember member) async {
  return false;
}



Future<bool> deleteMemberDocument(String gymownerid, int registerNumber) async {
  try {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('members')
        .where('gymownerid', isEqualTo: gymownerid)
        .where('registerNumber', isEqualTo: registerNumber)
        .get();

    if (snapshot.docs.isNotEmpty) {
      await snapshot.docs.first.reference.delete();
      return true; 
    } else {
      return false; 
    }
  } catch (e) {
    print('Error deleting document: $e');
    return false; 
  }
}
