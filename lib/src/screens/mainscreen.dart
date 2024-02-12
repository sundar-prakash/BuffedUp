import 'package:BuffedUp/src/screens/auth/aboutscreen.dart';
import 'package:BuffedUp/src/screens/home/maintanancescreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:BuffedUp/src/screens/auth/authscreen.dart';
import 'package:BuffedUp/src/screens/home/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool isMaintenanceEnabled = false;

  @override
  void initState() {
    super.initState();
    fetchMaintenanceStatus();
  }

  Future<void> fetchMaintenanceStatus() async {
    try {
      FirebaseFirestore.instance
          .collection('admin')
          .doc('settings')
          .snapshots()
          .listen((snapshot) {
        final data = snapshot.data();
        if (data != null && data['isMaintenanceEnabled'] != null) {
          setState(() {
            isMaintenanceEnabled = data['isMaintenanceEnabled'];
          });
        }
      });
    } catch (e) {
      print('Error fetching maintenance status: $e');
    }
  }

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
            if (isMaintenanceEnabled) {
              return MaintenanceScreen();
            } else {
              return HomeScreen();
            }
          }
        } else {
          return const AuthScreen();
        }
      },
    );
  }
}
