// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyDRWgCimXhQku4JdRdIs4T5sbVnVd7Liro',
    appId: '1:377968466678:web:0a8a793f646f24da63aad7',
    messagingSenderId: '377968466678',
    projectId: 'challengeone-94ab2',
    authDomain: 'challengeone-94ab2.firebaseapp.com',
    storageBucket: 'challengeone-94ab2.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAGG2arLdHeSEKAvgoZzoHQTk58LnSVqMc',
    appId: '1:377968466678:android:46758b712738cdba63aad7',
    messagingSenderId: '377968466678',
    projectId: 'challengeone-94ab2',
    storageBucket: 'challengeone-94ab2.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB8g_4EfTXKOCQ81ASaloIfDRQT7y7gag0',
    appId: '1:377968466678:ios:49d6d9c15610fdee63aad7',
    messagingSenderId: '377968466678',
    projectId: 'challengeone-94ab2',
    storageBucket: 'challengeone-94ab2.appspot.com',
    iosBundleId: 'com.joonseo1227.challengeone',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB8g_4EfTXKOCQ81ASaloIfDRQT7y7gag0',
    appId: '1:377968466678:ios:49d6d9c15610fdee63aad7',
    messagingSenderId: '377968466678',
    projectId: 'challengeone-94ab2',
    storageBucket: 'challengeone-94ab2.appspot.com',
    iosBundleId: 'com.joonseo1227.challengeone',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDRWgCimXhQku4JdRdIs4T5sbVnVd7Liro',
    appId: '1:377968466678:web:578c41f9ea99396c63aad7',
    messagingSenderId: '377968466678',
    projectId: 'challengeone-94ab2',
    authDomain: 'challengeone-94ab2.firebaseapp.com',
    storageBucket: 'challengeone-94ab2.appspot.com',
  );
}
