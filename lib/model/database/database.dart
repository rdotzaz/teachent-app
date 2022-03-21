import 'package:flutter/material.dart';

import 'hive_adapter.dart';
import 'firebase_adapter.dart';

enum DBMode { testing, release }

abstract class IDatabase {
  @protected
  final DBMode dbMode;

  IDatabase(this.dbMode);

  void init();
  void clear();
}

class MainDatabase extends IDatabase {
  final FirebaseRealTimeDatabaseAdapter _firebaseRealTimeDatabaseAdapter =
      FirebaseRealTimeDatabaseAdapter();
  final HiveDatabaseAdapter _hiveDatabaseAdapter = HiveDatabaseAdapter();

  MainDatabase(DBMode dbMode) : super(dbMode);

  @override
  void init() {
    _firebaseRealTimeDatabaseAdapter.init(dbMode);
    _hiveDatabaseAdapter.init(dbMode);
  }

  @override
  void clear() {
    _firebaseRealTimeDatabaseAdapter.clear();
    _hiveDatabaseAdapter.clear();
  }
}
