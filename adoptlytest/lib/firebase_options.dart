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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyALrgRxs2BCyHGID1cGCbRI33_mCunlEMY',
    appId: '1:811296145952:ios:dbce5fc033765df646b245',
    messagingSenderId: '811296145952',
    projectId: 'adoptly-beeb2',
    storageBucket: 'adoptly-beeb2.firebasestorage.app',
    iosBundleId: 'com.example.petshelter',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBkOtKtmaZFA7Ari_kls8_hFH55IQHHDsQ',
    appId: '1:348753193247:android:7782e3e4fb509172baa82a',
    messagingSenderId: '348753193247',
    projectId: 'adeptly-54c64',
    storageBucket: 'adeptly-54c64.firebasestorage.app',
  );

}