import 'package:BuffedUp/src/screens/auth/aboutscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:BuffedUp/src/screens/auth/authscreen.dart';
import 'package:BuffedUp/src/screens/home/homescreen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data?.displayName == null &&
              snapshot.data?.photoURL == null) {
            return const AboutScreen();
          } else {
            return const HomeScreen();
          }
        } else {
          return const AuthScreen();
        }
      },
    );
  }
}
