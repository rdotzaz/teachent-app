import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:teachent_app/common/algorithms.dart';
import 'package:teachent_app/common/firebase_options.dart'; // ignore: uri_does_not_exist
import 'package:teachent_app/database/database.dart';

import '../../common/consts.dart' show DatabaseConsts, DatabaseObjectName;

// Last UTF-8 character based on https://www.charset.org/utf-8/100
const lastCharacter = '\u1869F';

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

  static Future<Map> findUserByLoginAndCheckPassword(
      String login, String password) async {
    var databaseReference =
        FirebaseDatabase.instance.ref('${DatabaseObjectName.users}/$login');

    var event = await databaseReference.once();
    var isKeyExists = event.snapshot.exists;
    var foundEventValue = event.snapshot.value;

    if (!isKeyExists) {
      print('[FirebaseAdapter] No login found');
      return {};
    }

    if (foundEventValue == null) {
      print('[FirebaseAdapter] No body found');
      return {};
    }

    String encryptedPassword =
        (foundEventValue as DBValues)['password'] ?? DatabaseConsts.emptyField;

    if (encryptedPassword == DatabaseConsts.emptyField) {
      print('[FirebaseAdapter] No password found');
      return {};
    }

    var comparsionResult = isPasswordCorrect(password, encryptedPassword);

    if (!comparsionResult) {
      print('[FirebaseAdapter] Password does not match');
      return {};
    }
    return foundEventValue;
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
      String collectionName, String keyId, DBValues values) async {
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref().child(collectionName);

    final possibleExistedKeyRef = databaseReference.child(keyId);

    final event = await possibleExistedKeyRef.once();
    final isKeyExists = event.snapshot.exists;

    if (isKeyExists) {
      print('[FirebaseAdapter] User is already exists');
      return false;
    }

    /// [TODO] RESOLVE PRINTED EXCEPTION HERE
    await databaseReference.update({keyId: values});
    return true;
  }

  static Future<String> addDatabaseObjectWithNewKey(
      String collectionName, DBValues values) async {
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref().child(collectionName);

    final newKey = await databaseReference.push().key;
    if (newKey == null) {
      return DatabaseConsts.emptyKey;
    }
    await databaseReference.child(newKey).update(values);

    return newKey;
  }

  static Future<void> addObjects(String collectionName, DBValues values) async {
    var databaseReference = FirebaseDatabase.instance.ref(collectionName);

    await databaseReference.update(values);
  }

  static Future<Map> getObject(String collectionName, String key) async {
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref().child('$collectionName/$key');

    print('[Firebase Adapter] Key: $collectionName/$key');
    final event = await databaseReference.once();
    final isKeyExists = event.snapshot.exists;

    if (!isKeyExists) {
      print('[FirebaseAdapter] Object $collectionName/$key does not exist');
      return {};
    }

    return event.snapshot.value as Map<dynamic, dynamic>;
  }

  static Future<Map> getObjectsByName(
      String collectionName, String property, String name) async {
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref().child(collectionName);

    final query = databaseReference
        .orderByChild(property)
        .startAt(name)
        .endAt(name + lastCharacter);
    final event = await query.once();
    final values = event.snapshot.value;

    if (values == null) {
      return {};
    }
    return values as Map<dynamic, dynamic>;
  }

  static Future<void> addForeignKey(String collectionName, String id,
      String property, String foreginId) async {
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref().child('$collectionName/$id/$property');

    await databaseReference.update({foreginId: true});
  }

  static Future<String> getForeignKey(
      String collectionName, String id, String property) async {
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref().child('$collectionName/$id/$property');

    final event = await databaseReference.once();
    final isKeyExists = event.snapshot.exists;

    if (!isKeyExists) {
      print('[FirebaseAdapter] Foreign key does not exist');
      return DatabaseConsts.emptyKey;
    }

    return event.snapshot.value as String;
  }

  static void clear() {}
}
