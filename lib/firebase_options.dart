// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBd1LLX2Wnm_8Qdntm0sd23jPshubW1Zns',
    appId: '1:1033391636520:web:ad27bd405df9ab2708751d',
    messagingSenderId: '1033391636520',
    projectId: 'fitrack-b494e',
    authDomain: 'fitrack-b494e.firebaseapp.com',
    storageBucket: 'fitrack-b494e.appspot.com',
    measurementId: 'G-CMSKH8H0S8',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDK5DmLIVGxvLD46fZDRPAwtdgraMl7gxQ',
    appId: '1:1033391636520:android:581877c7e67077f808751d',
    messagingSenderId: '1033391636520',
    projectId: 'fitrack-b494e',
    storageBucket: 'fitrack-b494e.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCnc5Ix7316t6SEMOqYEDUOVVeriqCEFPU',
    appId: '1:1033391636520:ios:24fda4c7351c9b4308751d',
    messagingSenderId: '1033391636520',
    projectId: 'fitrack-b494e',
    storageBucket: 'fitrack-b494e.appspot.com',
    iosBundleId: 'com.example.fitrack',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCnc5Ix7316t6SEMOqYEDUOVVeriqCEFPU',
    appId: '1:1033391636520:ios:ee88b1b03b888b9308751d',
    messagingSenderId: '1033391636520',
    projectId: 'fitrack-b494e',
    storageBucket: 'fitrack-b494e.appspot.com',
    iosBundleId: 'com.example.fitrack.RunnerTests',
  );
}
