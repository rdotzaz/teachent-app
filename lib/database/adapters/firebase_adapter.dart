import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:teachent_app/common/algorithms.dart';
import 'package:teachent_app/common/firebase_options.dart'; // ignore: uri_does_not_exist
import 'package:teachent_app/database/database.dart';

import '../../common/consts.dart' show DatabaseConsts, DatabaseObjectName;

// Last UTF-8 character based on https://www.charset.org/utf-8/100
const lastCharacter = '\u1869F';

/// Class with static methods to communicate with FirebaseDatabase
class FirebaseRealTimeDatabaseAdapter {
  /// Method initializes database after starting app.
  /// Needs to be called before runApp() function.
  /// If [dbMode] is DBMode.testing, then firebase emulator is set as well.
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

  /// Method returns User database object with key-values
  /// with matching login and password.
  /// Return empty map if such user has not been found.
  static Future<Map> findUserByLoginAndCheckPassword(
      String login, String password) async {
    var databaseReference =
        FirebaseDatabase.instance.ref('${DatabaseObjectName.users}/$login');

    var event = await databaseReference.once();
    var isKeyExists = event.snapshot.exists;
    var foundEventValue = event.snapshot.value;

    if (!isKeyExists) {
      return {'error': 'login'};
    }

    if (foundEventValue == null) {
      return {};
    }

    String encryptedPassword =
        (foundEventValue as DBValues)['password'] ?? DatabaseConsts.emptyField;

    if (encryptedPassword == DatabaseConsts.emptyField) {
      return {};
    }

    var comparsionResult = isPasswordCorrect(password, encryptedPassword);

    if (!comparsionResult) {
      return {'error': 'password'};
    }
    return foundEventValue;
  }

  /// Returns map object with values of type bool.
  /// It corresponds to objects like topics, tools, places etc.
  /// For instance [collectionName]=topics, returns
  ///
  /// {
  ///   "Math": true,
  ///   "Computer Science": true
  /// }
  static Future<DBValues<bool>> getAvailableObjects(
      String collectionName) async {
    var databaseReference = FirebaseDatabase.instance.ref(collectionName);

    var event = await databaseReference.once();
    var isKeyExists = event.snapshot.exists;
    var foundValues = event.snapshot.value as Map<String, dynamic>;

    if (!isKeyExists) {
      return {};
    }

    if (foundValues.isEmpty) {
      return {};
    }
    return {
      for (var entry in foundValues.entries) entry.key: (entry.value as bool)
    };
  }

  /// Returns true if object has been successfully added to database.
  /// [collectionName] like "teachers", "students"
  /// [keyId] key identifies object in [collectionName]
  /// [userValues] map representation of object
  static Future<bool> addDatabaseObject(
      String collectionName, String keyId, DBValues values) async {
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref().child(collectionName);

    final possibleExistedKeyRef = databaseReference.child(keyId);

    final event = await possibleExistedKeyRef.once();
    final isKeyExists = event.snapshot.exists;

    if (isKeyExists) {
      return false;
    }

    /// TODO - RESOLVE PRINTED EXCEPTION HERE
    await databaseReference.update({keyId: values});
    return true;
  }

  static Future<String> addDatabaseObjectWithNewKey(
      String collectionName, DBValues values) async {
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref().child(collectionName);

    final newKey = databaseReference.push().key;
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

  /// Returns map representaion of object from [collectionName] with [key]
  /// It means that method returns values from [collectionName]/[key]
  /// If [collectionName]/[key] record does not exist in database method returns empty map object
  static Future<Map> getObject(String collectionName, String key) async {
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref().child('$collectionName/$key');

    print('[Firebase Adapter] Key: $collectionName/$key');
    final event = await databaseReference.once();
    final isKeyExists = event.snapshot.exists;

    if (!isKeyExists) {
      return {};
    }

    return event.snapshot.value as Map<dynamic, dynamic>;
  }

  /// Returns map representation of object from [collectionName]/{teachers/students}
  /// where [collectionName]/{teachers/students}/name value is matching with [name]
  /// Returns empty map if object has not been found
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

  /// Returns map representation of objects from [collectionName]
  /// where id/[property] has [value]
  /// Returns empty map if objects have not been found
  static Future<Map> getObjectsByProperty<Value>(
      String collectionName, String property, Value value) async {
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref().child(collectionName);

    final query = databaseReference.orderByChild(property).equalTo(value);
    final event = await query.once();
    final values = event.snapshot.value;

    if (values == null) {
      return {};
    }
    return values as Map<dynamic, dynamic>;
  }

  /// Method adds or updates [value] key to [collectionName]/[id]/[path]
  static Future<void> updateField<Value>(
      String collectionName, String id, String path, Value value) async {
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref().child('$collectionName/$id/$path');

    if (value is Map<String, Object?>) {
      await databaseReference.update(value);
    } else {
      await databaseReference.set(value);
    }
  }

  /// Method retrives foreign key from [collectionName]/[id]/[property]
  static Future<String> getForeignKey(
      String collectionName, String id, String property) async {
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref().child('$collectionName/$id/$property');

    final event = await databaseReference.once();
    final isKeyExists = event.snapshot.exists;

    if (!isKeyExists) {
      return DatabaseConsts.emptyKey;
    }

    return event.snapshot.value as String;
  }

  static void clear() {}
}
