import 'package:BuffedUp/const/DataTypes/GymMember.dart';
import 'package:BuffedUp/src/services/firestore/ownerdoc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future createMemberDocument(GymMember member) async {
  try {
    final docRef = FirebaseFirestore.instance.collection('members').doc();
    await docRef.set(member.toMap());
    await updateOwner('members', FieldValue.arrayUnion([docRef.id]));
    return true;
  } catch (e) {
    return false;
  }
}

Future<bool> updateMember(GymMember member) async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('members')
        .where('gymownerid', isEqualTo: member.gymownerid)
        .where('registerNumber', isEqualTo: member.registerNumber)
        .get();

    await querySnapshot.docs.first.reference
        .set(member.toMap(), SetOptions(merge: true));

    return true;
  } catch (e) {
    print('Error updating member: $e');
    return false;
  }
}

Future<bool> updateMemberField(GymMember member, String key, value) async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('members')
        .where('gymownerid', isEqualTo: member.gymownerid)
        .where('registerNumber', isEqualTo: member.registerNumber)
        .get();
    await querySnapshot.docs.first.reference.update({key: value});
    return true;
  } catch (e) {
    return false;
  }
}

Future<bool> deleteMemberDocument(String gymownerid, int registerNumber) async {
  try {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('members')
        .where('gymownerid', isEqualTo: gymownerid)
        .where('registerNumber', isEqualTo: registerNumber)
        .get();

    if (snapshot.docs.isNotEmpty) {
      await updateOwner('members',
          FieldValue.arrayRemove([snapshot.docs.first.reference.id]));
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
