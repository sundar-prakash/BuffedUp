import 'dart:io';
import 'package:BuffedUp/const/DataTypes/UserProfile.dart';
import 'package:BuffedUp/src/services/authService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<void> createUserDocument(String uid, String email) async {
  final docRef = FirebaseFirestore.instance.collection('gymowner').doc(uid);
  final userProfile = UserProfile(
    uid: uid,
    email: email,
  );

  await docRef.set(userProfile.toMap());
}

Future<void> updateFirestoreProfile(
    String name, String avatarurl, String GymName, String bio) async {
  await updateProfile(displayName: name, photoUrl: avatarurl);
  String docId = FirebaseAuth.instance.currentUser!.uid;
  final docRef = _firestore.collection('gymowner').doc(docId);

  await docRef.update(
      {'name': name, 'avatar': avatarurl, 'gymname': GymName, 'bio': bio});
}

Future<bool> updateOwner(String key, value) async {
  try {
    String docId = FirebaseAuth.instance.currentUser!.uid;
    final docRef = _firestore.collection('gymowner').doc(docId);

    await docRef.update({key: value});
    return true;
  } catch (e) {
    return false;
  }
}

Future<UserProfile> fetchOwner() async {
  String docId = FirebaseAuth.instance.currentUser!.uid;
  final docRef = _firestore.collection('gymowner').doc(docId);
  DocumentSnapshot<Map<String, dynamic>> snapshot = await docRef.get();
  if (snapshot.exists) {
    Map<String, dynamic> data = snapshot.data()!;
    return UserProfile.fromMap(data);
  } else {
    throw Exception('Document does not exist');
  }
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
Future<List<dynamic>> FetchField(String field) async {
  String docId = FirebaseAuth.instance.currentUser!.uid;
  final docRef = FirebaseFirestore.instance.collection('gymowner').doc(docId);
  final docSnapshot = await docRef.get();

  if (docSnapshot.exists) {
    final data = docSnapshot.data()?[field] as List?;
    if (data != null) {
      return data;
    } else {
      return []; 
    }
  } else {
    return []; 
  }
}


