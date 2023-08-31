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
    apiKey: 'AIzaSyB9NOZb5cpqexolcfOv2VmdeJVWg7KUcaY',
    appId: '1:841686736797:web:2cd624703b268d1148d974',
    messagingSenderId: '841686736797',
    projectId: 'mco-quizrd',
    authDomain: 'mco-quizrd.firebaseapp.com',
    storageBucket: 'mco-quizrd.appspot.com',
    measurementId: "G-2X66S3160C",
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDjlZAUeGlsFHxTgzO0f0SbvFWPMtSdaVI',
    appId: '1:841686736797:android:7bf9678db07dd7cd48d974',
    messagingSenderId: '841686736797',
    projectId: 'mco-quizrd',
    storageBucket: 'mco-quizrd.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCNUJAa1QBAAP6WfgoUI_CwGxdiacZzwKw',
    appId: '1:338739261213:ios:cfab9adc7d4a1563be7bf4',
    messagingSenderId: '841686736797',
    projectId: 'mco-quizrd',
    storageBucket: 'mco-quizrd.appspot.com',
    iosClientId:
        '841686736797-25ib2nurttbn2p7k1hkqhauqcjet1l8j.apps.googleusercontent.com',
    iosBundleId: 'com.example.quizrd',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDGB9uaGkJMnMLcRPISIWjibwfMV8xT-kk',
    appId: '1:338739261213:ios:8bb9c6349a0308a3be7bf4',
    messagingSenderId: '841686736797',
    projectId: 'mco-quizrd',
    storageBucket: 'mco-quizrd.appspot.com',
    iosClientId:
        '841686736797-25ib2nurttbn2p7k1hkqhauqcjet1l8j.apps.googleusercontent.com',
    iosBundleId: 'com.example.quizrd',
  );
}
