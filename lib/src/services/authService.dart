import 'package:BuffedUp/src/services/firestore/ownerdoc.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<String> register(email, password) async {
  try {
    if (email == "" || password == "") return "Please Fill All Fields";
    UserCredential newUser = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    createUserDocument(newUser.user!.uid,email);
    return ('User registered successfully!');
  } on FirebaseAuthException catch (e) {
    return (e.message ?? "Something Went Wrong");
  }
}

Future<String> login(email, password) async {
  try {
    if (email == "" || password == "") return "Please Fill All Fields";
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return ('User registered successfully!');
  } on FirebaseAuthException catch (e) {
    print(e);
    return (e.message ?? "Something Went Wrong");
  }
}

Future<void> updateProfile({
  required String displayName,
  required String photoUrl,
}) async {
  await FirebaseAuth.instance.currentUser!.updateDisplayName(displayName);
  await FirebaseAuth.instance.currentUser!.updatePhotoURL(photoUrl);
  // await FirebaseAuth.instance.currentUser!.updatePhoneNumber(photoUrl);
}
void logout() async {
  await FirebaseAuth.instance.signOut();
}
