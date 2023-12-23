import 'dart:io';

import 'package:BuffedUp/const/DataTypes/GymMember.dart';
import 'package:BuffedUp/const/DataTypes/UserProfile.dart';
import 'package:BuffedUp/src/services/authService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<void> createUserDocument(String uid, String email) async {
  final docRef = FirebaseFirestore.instance.collection('users').doc(uid);

  final userProfile = UserProfile(
    uid: uid,
    email: email,
  );

  await docRef.set(userProfile.toMap());
}

Future<void> updateFirestoreProfile(
    String name, String avatarurl, String GymName, String bio) async {
  await updateProfile(displayName: name, photoUrl: avatarurl);
  final docId = FirebaseAuth.instance.currentUser!.uid;
  final docRef = _firestore.collection('users').doc(docId);
  await docRef.update(
      {'name': name, 'avatar': avatarurl, 'gymname': GymName, 'bio': bio});
}

Future<bool> uploadMember(GymMember member) async {
  final docId = FirebaseAuth.instance.currentUser!.uid;

  final data = member.toMap();

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

Future<String?> uploadImageToFirebase(
    XFile imageFile, String folderName, String fileName) async {
  final storageRef =
      FirebaseStorage.instance.ref().child(folderName).child('$fileName.jpg');

  try {
    await storageRef.putFile(File(imageFile.path));
    final downloadUrl = await storageRef.getDownloadURL();
    return downloadUrl;
  } on FirebaseException catch (e) {
    print('Error uploading image: $e');
    return null;
  }
}
