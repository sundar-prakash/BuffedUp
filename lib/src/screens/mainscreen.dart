import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitrack/src/screens/auth/authscreen.dart';
import 'package:fitrack/src/screens/home/homescreen.dart';
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
          return const homescreeen();
        } else {
          return const auth();
        }
      },
    );
  }
}
