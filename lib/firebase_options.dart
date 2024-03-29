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
    apiKey: 'AIzaSyATsM3fzope-6PTpLBJYx6iKfykU6YIqok',
    appId: '1:772748166970:web:56e40db85b047f3d34b203',
    messagingSenderId: '772748166970',
    projectId: 'tabib-56f14',
    authDomain: 'tabib-56f14.firebaseapp.com',
    storageBucket: 'tabib-56f14.appspot.com',
    measurementId: 'G-RGYGVLFVZR',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCdabasdz5eYK4jfV-H10jsE1QH6b-ceyo',
    appId: '1:772748166970:android:b730c12acaba931834b203',
    messagingSenderId: '772748166970',
    projectId: 'tabib-56f14',
    storageBucket: 'tabib-56f14.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDCiMVRQC1YLfeb0SL1mJDBywD49xE4sDY',
    appId: '1:772748166970:ios:8639d940e985a5e634b203',
    messagingSenderId: '772748166970',
    projectId: 'tabib-56f14',
    storageBucket: 'tabib-56f14.appspot.com',
    iosClientId: '772748166970-rnl9cd6a6as03gnl229is2hd0aoq1g7o.apps.googleusercontent.com',
    iosBundleId: 'com.clinical.tibei.clinic',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDCiMVRQC1YLfeb0SL1mJDBywD49xE4sDY',
    appId: '1:772748166970:ios:8639d940e985a5e634b203',
    messagingSenderId: '772748166970',
    projectId: 'tabib-56f14',
    storageBucket: 'tabib-56f14.appspot.com',
    iosClientId: '772748166970-rnl9cd6a6as03gnl229is2hd0aoq1g7o.apps.googleusercontent.com',
    iosBundleId: 'com.clinical.tibei.clinic',
  );
}
