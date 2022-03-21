import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:teachent_app/model/database/database.dart';
import 'package:teachent_app/model/database/database_adapter.dart';

import '../../common/consts.dart' show DatabaseConsts;

class FirebaseRealTimeDatabaseAdapter extends BaseDatabaseAdapter {
  String? realTimeDatabaseHost;
  int emulatorPort = DatabaseConsts.emulatorPort;

  @override
  void init(DBMode dbMode) {
    _setHost(dbMode);
    _startDataBase(dbMode);
  }

  @override
  void clear() {}

  void _setHost(DBMode dbMode) {
    if (dbMode == DBMode.testing) {
      realTimeDatabaseHost = Platform.isAndroid
          ? DatabaseConsts.androidFirebaseHost
          : DatabaseConsts.webFirebaseHost;
    } else {
      // TODO
      // Set real host
    }
  }

  void _startDataBase(DBMode dbMode) {
    if (dbMode == DBMode.testing) {
      FirebaseDatabase.instance
          .useDatabaseEmulator(realTimeDatabaseHost!, emulatorPort);
    } else {
      // TOOD
      // Set real host
    }
  }
}
