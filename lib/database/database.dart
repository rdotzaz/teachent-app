import 'package:flutter/material.dart';
import 'package:teachent_app/database/adapters/firebase_adapter.dart';
import 'package:teachent_app/database/methods/student_methods.dart';
import 'package:teachent_app/database/methods/teacher_methods.dart';

import 'methods/user_methods.dart';
import 'adapters/hive_adapter.dart';

typedef DBValues = Map<String, dynamic>;

enum DBMode { testing, release }

abstract class IDatabase {
  @protected
  final DBMode dbMode;

  IDatabase(this.dbMode);

  Future<void> init();
  void clear();
}

class MainDatabase extends IDatabase
    with UserDatabaseMethods, TeacherDatabaseMethods, StudentDatabaseMethods {
  MainDatabase(DBMode dbMode) : super(dbMode);

  @override
  Future<void> init() async {
    await FirebaseRealTimeDatabaseAdapter.init(dbMode);
    HiveDatabaseAdapter.init();
  }

  @override
  void clear() {
    FirebaseRealTimeDatabaseAdapter.clear();
    HiveDatabaseAdapter.clear();
  }
}
