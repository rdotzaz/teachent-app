import 'package:flutter/material.dart';
import 'package:teachent_app/database/adapters/firebase_adapter.dart';
import 'package:teachent_app/database/methods/configuration_methods.dart';
import 'package:teachent_app/database/methods/student_methods.dart';
import 'package:teachent_app/database/methods/teacher_methods.dart';

import 'methods/user_methods.dart';
import 'adapters/hive_adapter.dart';

typedef DBValues = Map<String, dynamic>;

enum DBMode { testing, release }

abstract class IDatabase {
  Future<void> init(DBMode dbMode);
  void clear();
}

class MainDatabase extends IDatabase
    with
        AppConfigartionMethods,
        UserDatabaseMethods,
        TeacherDatabaseMethods,
        StudentDatabaseMethods {
  @override
  Future<void> init(DBMode dbMode) async {
    await FirebaseRealTimeDatabaseAdapter.init(dbMode);
    await HiveDatabaseAdapter.init();
  }

  @override
  void clear() {
    FirebaseRealTimeDatabaseAdapter.clear();
    HiveDatabaseAdapter.clear();
  }
}
