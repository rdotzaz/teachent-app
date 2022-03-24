import 'dart:developer' as dev;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:teachent_app/common/algorithms.dart';
import 'package:teachent_app/common/firebase_options.dart'; // ignore: uri_does_not_exist
import 'package:teachent_app/database/database.dart';

import '../../common/consts.dart' show DatabaseConsts, DatabaseObjectName;

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
        ? androidFirebaseOption // ignore: undefined_identifier
        : webFirebaseOption; // ignore: undefined_identifier

    await Firebase.initializeApp(options: firebaseOptions);

    if (dbMode == DBMode.testing) {
      var databaseHost = _getHost(dbMode);
      FirebaseDatabase.instance
          .useDatabaseEmulator(databaseHost, DatabaseConsts.emulatorPort);
    }
  }

  static void addUser(String keyId, DBValues userValues) async {
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref().child(DatabaseObjectName.users);

    await databaseReference.child(keyId).set(userValues);
  }

  static Future<String> findUserByLoginAndCheckPassword(
      String login, String password) async {
    var databaseReference =
        FirebaseDatabase.instance.ref('${DatabaseObjectName.users}/$login');
    var foundKey = databaseReference.key;

    if (foundKey == null) {
      return DatabaseConsts.emptyKey;
    }

    var event = await databaseReference.once();
    var foundEventValue = event.snapshot.value;

    if (foundEventValue == null) {
      dev.log('[FirebaseAdapter] Login exists, but with empty body');
      return DatabaseConsts.emptyKey;
    }

    String encryptedPassword =
        (foundEventValue as Map<String, dynamic>)['password'] ??
            DatabaseConsts.emptyField;

    if (encryptedPassword == DatabaseConsts.emptyField) {
      dev.log('[FirebaseAdapter] Login exists, but without password');
      return DatabaseConsts.emptyKey;
    }

    var comparsionResult = isPasswordCorrect(password, encryptedPassword);

    return DatabaseConsts.emptyKey;
  }

  static void clear() {}
}
