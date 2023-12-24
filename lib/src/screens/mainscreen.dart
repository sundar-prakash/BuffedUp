import 'package:BuffedUp/src/screens/auth/aboutscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:BuffedUp/src/screens/auth/authscreen.dart';
import 'package:BuffedUp/src/screens/home/homescreen.dart';
import 'package:flutter/material.dart';

class mainscreen extends StatefulWidget {
  const mainscreen({super.key});

  @override
  State<mainscreen> createState() => _mainscreenState();
}

class _mainscreenState extends State<mainscreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data?.displayName == null &&
              snapshot.data?.photoURL == null) {
            return const aboutscreen();
          } else {
            return const homescreen();
          }
        } else {
          return const auth();
        }
      },
    );
  }
}
