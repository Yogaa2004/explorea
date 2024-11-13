// lib/firebase_options.dart
// GENERATED FILE - DO NOT MODIFY BY HAND

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      // Tambahkan platform iOS atau lainnya jika diperlukan
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions tidak mendukung platform ini.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyALcnSU_8Nb08R_pZpSHdgAM6jsyN2xtek',
    appId: '1:388405011819:web:015c1f2282b7deb40e182e',
    messagingSenderId: '388405011819',
    projectId: 'project-shadow-46f77',
    authDomain: 'project-shadow-46f77.firebaseapp.com',
    storageBucket: 'project-shadow-46f77.appspot.com',
    measurementId: 'G-CJCK3KS42K',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCSszBuz7XzDgt1FfBQ4oIESi3Y1JxNPVs',
    appId: '1:388405011819:android:bcc21e6f57afb9ac0e182e',
    messagingSenderId: '388405011819',
    projectId: 'project-shadow-46f77',
    storageBucket: 'project-shadow-46f77.appspot.com',
  );

  // Tambahkan opsi untuk iOS atau lainnya jika dibutuhkan
}
