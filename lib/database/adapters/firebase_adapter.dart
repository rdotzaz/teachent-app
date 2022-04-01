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

    if (defaultTargetPlatform == TargetPlatform.android) {
      await Firebase.initializeApp();
    } else {
      await Firebase.initializeApp(options: firebaseOptions);
    }

    if (dbMode == DBMode.testing) {
      var databaseHost = _getHost(dbMode);
      print('[Host] $databaseHost');
      FirebaseDatabase.instance
          .useDatabaseEmulator(databaseHost, DatabaseConsts.emulatorPort);
    }
  }

  static Future<String> findUserByLoginAndCheckPassword(
      String login, String password) async {
    //FirebaseDatabase.instance.setLoggingEnabled(true);
    print('[FirebaseAdapter] findUserByLogin');
    var databaseReference =
        FirebaseDatabase.instance.ref('${DatabaseObjectName.users}/$login');

    print('Before once. ${databaseReference.key}');
    var event = await databaseReference.once();
    print('After once');
    var isKeyExists = event.snapshot.exists;
    var foundEventValue = event.snapshot.value;

    if (!isKeyExists) {
      print('[FirebaseAdapter] No login found');
      return DatabaseConsts.emptyKey;
    }

    if (foundEventValue == null) {
      print('[FirebaseAdapter] No body found');
      return DatabaseConsts.emptyKey;
    }

    String encryptedPassword =
        (foundEventValue as DBValues)['password'] ?? DatabaseConsts.emptyField;

    if (encryptedPassword == DatabaseConsts.emptyField) {
      print('[FirebaseAdapter] No password found');
      return DatabaseConsts.emptyKey;
    }

    var comparsionResult = isPasswordCorrect(password, encryptedPassword);

    if (!comparsionResult) {
      return DatabaseConsts.emptyKey;
    }
    return login;
  }

  static Future<DBValues<bool>> getAvailableObjects(
      String collectionName) async {
    var databaseReference = FirebaseDatabase.instance.ref(collectionName);

    var event = await databaseReference.once();
    var isKeyExists = event.snapshot.exists;
    var foundValues = event.snapshot.value as Map<String, dynamic>;

    if (!isKeyExists) {
      print('[FirebaseAdapter] Key $collectionName does not exist');
      return {};
    }

    if (foundValues.isEmpty) {
      print('[FirebaseAdapter] No $collectionName available');
      return {};
    }
    return {
      for (var entry in foundValues.entries) entry.key: (entry.value as bool)
    };
  }

  static Future<bool> addDatabaseObject(
      String collectionName, String keyId, DBValues userValues) async {
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref().child(collectionName);

    var possibleExistedKeyRef = databaseReference.child(keyId);

    var event = await possibleExistedKeyRef.once();
    var isKeyExists = event.snapshot.exists;

    if (isKeyExists) {
      print('[FirebaseAdapter] User is already exists');
      return false;
    }

    /// [TODO] RESOLVE PRINTED EXCEPTION HERE
    await databaseReference.update({keyId: userValues});
    return true;
  }

  static Future<void> addObjects(String collectionName, DBValues values) async {
    var databaseReference = FirebaseDatabase.instance.ref(collectionName);

    await databaseReference.update(values);
  }

  static Future<dynamic> getObject(String collectionName, String key) async {
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref().child('$collectionName/$key');

    print('[Firebase Adapter] Key: $collectionName/$key');
    print('Before once');
    final event = await databaseReference.once();
    print('After once');
    final isKeyExists = event.snapshot.exists;

    if (!isKeyExists) {
      print('[FirebaseAdapter] Object $collectionName/$key does not exist');
      return {};
    }

    print('Values: ${event.snapshot.value}');
    return event.snapshot.value as Map<dynamic, dynamic>;
  }

  static void clear() {}
}
