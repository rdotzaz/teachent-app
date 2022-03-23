import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:teachent_app/common/firebase_options.dart';
import 'package:teachent_app/database/database.dart';

import '../../common/consts.dart' show DatabaseConsts;

class FirebaseRealTimeDatabaseAdapter {
  static Future<void> init(DBMode dbMode) async {
    await _startDataBase(dbMode);
  }

  static String _getHost(DBMode dbMode) {
    return defaultTargetPlatform == TargetPlatform.android
        ? DatabaseConsts.androidFirebaseHost
        : DatabaseConsts.webFirebaseHost;
  }

  static Future<void> _startDataBase(DBMode dbMode) async {
    var firebaseOptions = defaultTargetPlatform == TargetPlatform.android
        ? androidFirebaseOption
        : webFirebaseOption;

    await Firebase.initializeApp(options: firebaseOptions);

    if (dbMode == DBMode.testing) {
      var databaseHost = _getHost(dbMode);
      FirebaseDatabase.instance
          .useDatabaseEmulator(databaseHost, DatabaseConsts.emulatorPort);
    }
  }

  static void addUser(DBValues userValues, String collectionName) async {
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref().child(collectionName);
    final newKeyId = databaseReference.push().key;

    await databaseReference.child(newKeyId!).set(userValues);
  }

  static void clear() {}
}
