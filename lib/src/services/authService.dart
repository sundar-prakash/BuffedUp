import 'package:firebase_auth/firebase_auth.dart';

Future<String> register(email, password) async {
  try {
    if (email == "" || password == "") return "Please Fill All Fields";
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
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
