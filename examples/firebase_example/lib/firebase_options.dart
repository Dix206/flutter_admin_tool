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
    apiKey: 'AIzaSyCCn2G4N7xpWriAqq7fkUDNpsPAD1Nn5x8',
    appId: '1:52969446647:web:467ce546393c45f7e007f2',
    messagingSenderId: '52969446647',
    projectId: 'flat-firebase-example',
    authDomain: 'flat-firebase-example.firebaseapp.com',
    storageBucket: 'flat-firebase-example.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC2seWHk7wvXveVYNeE4_pi9y_RR2N04Es',
    appId: '1:52969446647:android:9a335fe044425357e007f2',
    messagingSenderId: '52969446647',
    projectId: 'flat-firebase-example',
    storageBucket: 'flat-firebase-example.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDY9E2Y__jWPbvdPAvaEesR4oQ_ZIADE2E',
    appId: '1:52969446647:ios:0a2e6d91b1d90a84e007f2',
    messagingSenderId: '52969446647',
    projectId: 'flat-firebase-example',
    storageBucket: 'flat-firebase-example.appspot.com',
    iosClientId: '52969446647-2jemoe0dmmpua1jh4sesrv7jq79v67v0.apps.googleusercontent.com',
    iosBundleId: 'com.example.firebaseExample',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDY9E2Y__jWPbvdPAvaEesR4oQ_ZIADE2E',
    appId: '1:52969446647:ios:0a2e6d91b1d90a84e007f2',
    messagingSenderId: '52969446647',
    projectId: 'flat-firebase-example',
    storageBucket: 'flat-firebase-example.appspot.com',
    iosClientId: '52969446647-2jemoe0dmmpua1jh4sesrv7jq79v67v0.apps.googleusercontent.com',
    iosBundleId: 'com.example.firebaseExample',
  );
}