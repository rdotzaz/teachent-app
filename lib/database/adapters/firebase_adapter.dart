import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:teachent_app/common/algorithms.dart';
import 'package:teachent_app/common/enums.dart';
import 'package:teachent_app/common/firebase_enums.dart';
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

    await Firebase.initializeApp(options: firebaseOptions);

    if (dbMode == DBMode.testing &&
        defaultTargetPlatform != TargetPlatform.android) {
      var databaseHost = _getHost(dbMode);
      FirebaseDatabase.instance
          .useDatabaseEmulator(databaseHost, DatabaseConsts.emulatorPort);
    }
  }

  /// Method returns User database object with key-values
  /// with matching login and password.
  /// Returns firebase response with status and data.
  static Future<FirebaseResponse<Map>> findUserByLoginAndCheckPassword(
      String login, String password) async {
    final databaseReference =
        FirebaseDatabase.instance.ref('${DatabaseObjectName.users}/$login');

    late DataSnapshot snapshot;
    try {
      snapshot =
          await databaseReference.get().timeout(const Duration(seconds: 5));
    } on TimeoutException {
      return FirebaseResponse(
          status: FirebaseResponseStatus.failure,
          feedback: FirebaseFeedback.connectionError,
          data: {});
    }
    final isKeyExists = snapshot.exists;
    final foundEventValue = snapshot.value;

    if (!isKeyExists) {
      return FirebaseResponse(
          status: FirebaseResponseStatus.failure,
          feedback: FirebaseFeedback.noData,
          data: {},
          loginResult: LoginResult(status: LoginStatus.loginNotFound));
    }

    if (foundEventValue == null) {
      return FirebaseResponse(
          status: FirebaseResponseStatus.failure,
          feedback: FirebaseFeedback.noData,
          data: {},
          loginResult: LoginResult(status: LoginStatus.logicError));
    }

    String encryptedPassword =
        (foundEventValue as Map<dynamic, dynamic>)['password'] ??
            DatabaseConsts.emptyField;

    if (encryptedPassword == DatabaseConsts.emptyField) {
      return FirebaseResponse(
          status: FirebaseResponseStatus.failure,
          feedback: FirebaseFeedback.noData,
          data: {},
          loginResult: LoginResult(status: LoginStatus.logicError));
    }

    final comparsionResult = isPasswordCorrect(password, encryptedPassword);

    if (!comparsionResult) {
      return FirebaseResponse(
          status: FirebaseResponseStatus.failure,
          feedback: FirebaseFeedback.noData,
          data: {},
          loginResult: LoginResult(status: LoginStatus.invalidPassword));
    }
    return FirebaseResponse(
        status: FirebaseResponseStatus.success,
        feedback: FirebaseFeedback.none,
        data: foundEventValue,
        loginResult: LoginResult(status: LoginStatus.success));
  }

  /// Returns map object with values of type bool.
  /// It corresponds to objects like topics, tools, places etc.
  /// For instance [collectionName]=topics, returns
  ///
  /// {
  ///   "Math": true,
  ///   "Computer Science": true
  /// }
  static Future<FirebaseResponse<Map>> getAvailableObjects(
      String collectionName) async {
    final databaseReference = FirebaseDatabase.instance.ref(collectionName);

    late DatabaseEvent event;
    try {
      event =
          await databaseReference.once().timeout(const Duration(seconds: 8));
    } on TimeoutException {
      return FirebaseResponse(
          status: FirebaseResponseStatus.failure,
          feedback: FirebaseFeedback.connectionError,
          data: {});
    }
    final isKeyExists = event.snapshot.exists;
    final foundValues = event.snapshot.value as Map<dynamic, dynamic>;

    if (!isKeyExists) {
      return FirebaseResponse(
          status: FirebaseResponseStatus.failure,
          feedback: FirebaseFeedback.noData,
          data: {});
    }

    if (foundValues.isEmpty) {
      return FirebaseResponse(
          status: FirebaseResponseStatus.failure,
          feedback: FirebaseFeedback.noData,
          data: {});
    }
    return FirebaseResponse(
        status: FirebaseResponseStatus.success,
        feedback: FirebaseFeedback.none,
        data: {
          for (var entry in foundValues.entries)
            entry.key.toString(): (entry.value as bool)
        });
  }

  /// Returns response with success status if object has been successfully added to database.
  /// [collectionName] like "teachers", "students"
  /// [keyId] key identifies object in [collectionName]
  /// [values] map representation of object
  static Future<FirebaseResponse<Map>> addDatabaseObject(
      String collectionName, String keyId, DBValues values) async {
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref().child(collectionName);

    final possibleExistedKeyRef = databaseReference.child(keyId);

    late DatabaseEvent event;
    try {
      event = await possibleExistedKeyRef
          .once()
          .timeout(const Duration(seconds: 5));
    } on TimeoutException {
      return FirebaseResponse(
          status: FirebaseResponseStatus.failure,
          feedback: FirebaseFeedback.connectionError,
          data: {});
    }
    final isKeyExists = event.snapshot.exists;

    if (isKeyExists) {
      return FirebaseResponse(
          status: FirebaseResponseStatus.failure,
          feedback: FirebaseFeedback.keyAlreadyExists,
          data: {});
    }

    await databaseReference.update({keyId: values});
    return FirebaseResponse(
        status: FirebaseResponseStatus.success,
        feedback: FirebaseFeedback.none,
        data: {});
  }

  static Future<FirebaseResponse<String>> addDatabaseObjectWithNewKey(
      String collectionName, DBValues values) async {
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref().child(collectionName);

    final newKey = databaseReference.push().key;
    if (newKey == null) {
      return FirebaseResponse(
          status: FirebaseResponseStatus.failure,
          feedback: FirebaseFeedback.none,
          data: DatabaseConsts.emptyKey);
    }

    try {
      await databaseReference
          .child(newKey)
          .update(values)
          .timeout(const Duration(seconds: 10));
    } on TimeoutException {
      return FirebaseResponse(
          status: FirebaseResponseStatus.failure,
          feedback: FirebaseFeedback.connectionError,
          data: DatabaseConsts.emptyKey);
    }

    return FirebaseResponse(
        status: FirebaseResponseStatus.success,
        feedback: FirebaseFeedback.none,
        data: newKey);
  }

  static Future<FirebaseResponse<bool>> addObjects(
      String collectionName, DBValues values) async {
    final databaseReference = FirebaseDatabase.instance.ref(collectionName);

    try {
      await databaseReference
          .update(values)
          .timeout(const Duration(seconds: 10));
    } on TimeoutException {
      return FirebaseResponse(
          status: FirebaseResponseStatus.failure,
          feedback: FirebaseFeedback.connectionError,
          data: false);
    }
    return FirebaseResponse(
        status: FirebaseResponseStatus.success,
        feedback: FirebaseFeedback.none,
        data: true);
  }

  /// Returns map representaion of object from [collectionName] with [key]
  /// It means that method returns values from [collectionName]/[key]
  /// If [collectionName]/[key] record does not exist in database method returns response with empty map object
  static Future<FirebaseResponse<Map>> getObject(
      String collectionName, String key) async {
    if (key == DatabaseConsts.emptyKey) {
      return FirebaseResponse(
          status: FirebaseResponseStatus.failure,
          feedback: FirebaseFeedback.noData,
          data: {});
    }

    final databaseReference =
        FirebaseDatabase.instance.ref().child('$collectionName/$key');

    late DataSnapshot snapshot;
    try {
      snapshot =
          await databaseReference.get().timeout(const Duration(seconds: 5));
    } on TimeoutException {
      return FirebaseResponse(
          status: FirebaseResponseStatus.failure,
          feedback: FirebaseFeedback.connectionError,
          data: {});
    }

    final isKeyExists = snapshot.exists;
    if (!isKeyExists) {
      return FirebaseResponse(
          status: FirebaseResponseStatus.failure,
          feedback: FirebaseFeedback.noKeyFound,
          data: {});
    }

    return FirebaseResponse(
        status: FirebaseResponseStatus.success,
        feedback: FirebaseFeedback.none,
        data: snapshot.value as Map<dynamic, dynamic>);
  }

  /// Returns reponse with map representation of object from [collectionName]/{teachers/students}
  /// where [collectionName]/{teachers/students}/name value is matching with [name]
  /// Returns response with empty map if object has not been found
  static Future<FirebaseResponse<Map>> getObjectsByName(
      String collectionName, String property, String name) async {
    final databaseReference =
        FirebaseDatabase.instance.ref().child(collectionName);

    final query = databaseReference
        .orderByChild(property)
        .startAt(name)
        .endAt(name + lastCharacter);

    late DatabaseEvent event;
    try {
      event = await query.once().timeout(const Duration(seconds: 20));
    } on TimeoutException {
      return FirebaseResponse(
          status: FirebaseResponseStatus.failure,
          feedback: FirebaseFeedback.connectionError,
          data: {});
    }

    final values = event.snapshot.value;

    if (values == null) {
      return FirebaseResponse(
          status: FirebaseResponseStatus.failure,
          feedback: FirebaseFeedback.noData,
          data: {});
    }

    return FirebaseResponse(
        status: FirebaseResponseStatus.success,
        feedback: FirebaseFeedback.none,
        data: values as Map<dynamic, dynamic>);
  }

  /// Returns response with map representation of objects from [collectionName]
  /// where id/[property] has [value]
  /// Returns repsonse with empty map if objects have not been found
  static Future<FirebaseResponse<Map>> getObjectsByProperty<Value>(
      String collectionName, String property, Value value) async {
    final databaseReference =
        FirebaseDatabase.instance.ref().child(collectionName);

    if (value is String && value == DatabaseConsts.emptyField) {
      return FirebaseResponse(
          status: FirebaseResponseStatus.failure,
          feedback: FirebaseFeedback.noData,
          data: {});
    }

    final query = databaseReference.orderByChild(property).equalTo(value);

    late DatabaseEvent event;
    try {
      event = await query.once().timeout(const Duration(seconds: 10));
    } on TimeoutException {
      return FirebaseResponse(
          status: FirebaseResponseStatus.failure,
          feedback: FirebaseFeedback.connectionError,
          data: {});
    }

    final values = event.snapshot.value;
    if (values == null) {
      return FirebaseResponse(
          status: FirebaseResponseStatus.failure,
          feedback: FirebaseFeedback.noData,
          data: {});
    }

    return FirebaseResponse(
        status: FirebaseResponseStatus.success,
        feedback: FirebaseFeedback.none,
        data: values as Map<dynamic, dynamic>);
  }

  /// Method adds or updates [value] key to [collectionName]/[id]/[path]
  static Future<FirebaseResponse<bool>> updateField<Value>(
      String collectionName, String id, String path, Value value) async {
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref().child('$collectionName/$id/$path');

    try {
      if (value is Map<String, Object?>) {
        await databaseReference
            .update(value)
            .timeout(const Duration(seconds: 5));
      } else {
        await databaseReference.set(value).timeout(const Duration(seconds: 5));
      }
    } on TimeoutException {
      return FirebaseResponse(
          status: FirebaseResponseStatus.failure,
          feedback: FirebaseFeedback.connectionError,
          data: false);
    }

    return FirebaseResponse(
        status: FirebaseResponseStatus.success,
        feedback: FirebaseFeedback.none,
        data: true);
  }

  /// Method adds or updates [value] key to [collectionName]/[id]
  static Future<FirebaseResponse<bool>> updateMapField(
      String collectionName, String id, Map<String, Object?> value) async {
    final databaseReference =
        FirebaseDatabase.instance.ref().child('$collectionName/$id');

    try {
      await databaseReference.update(value).timeout(const Duration(seconds: 8));
    } on TimeoutException {
      return FirebaseResponse(
          status: FirebaseResponseStatus.failure,
          feedback: FirebaseFeedback.connectionError,
          data: false);
    }

    return FirebaseResponse(
        status: FirebaseResponseStatus.success,
        feedback: FirebaseFeedback.none,
        data: true);
  }

  /// Method retrives foreign key from [collectionName]/[id]/[property]
  static Future<FirebaseResponse<String>> getForeignKey(
      String collectionName, String id, String property) async {
    final databaseReference =
        FirebaseDatabase.instance.ref().child('$collectionName/$id/$property');

    late DatabaseEvent event;
    try {
      event =
          await databaseReference.once().timeout(const Duration(seconds: 5));
    } on TimeoutException {
      return FirebaseResponse(
          status: FirebaseResponseStatus.failure,
          feedback: FirebaseFeedback.connectionError,
          data: DatabaseConsts.emptyKey);
    }

    final isKeyExists = event.snapshot.exists;

    if (!isKeyExists) {
      return FirebaseResponse(
          status: FirebaseResponseStatus.failure,
          feedback: FirebaseFeedback.noKeyFound,
          data: DatabaseConsts.emptyKey);
    }

    return FirebaseResponse(
        status: FirebaseResponseStatus.success,
        feedback: FirebaseFeedback.none,
        data: event.snapshot.value as String);
  }

  static void clear() {}
}
