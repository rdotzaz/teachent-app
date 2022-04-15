import 'package:teachent_app/database/adapters/firebase_adapter.dart';
import 'package:teachent_app/database/methods/configuration_methods.dart';
import 'package:teachent_app/database/methods/education_level_methods.dart';
import 'package:teachent_app/database/methods/lesson_date_methods.dart';
import 'package:teachent_app/database/methods/place_methods.dart';
import 'package:teachent_app/database/methods/student_methods.dart';
import 'package:teachent_app/database/methods/teacher_methods.dart';
import 'package:teachent_app/database/methods/tool_methods.dart';
import 'package:teachent_app/database/methods/topic_methods.dart';

import 'methods/user_methods.dart';
import 'adapters/hive_adapter.dart';

typedef DBValues<Value> = Map<String, Value>;

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
        StudentDatabaseMethods,
        TopicDatabaseMethods,
        ToolsDatabaseMethods,
        PlaceDatabaseMethods,
        EducationLevelDatabaseMethods,
        LessonDateDatabaseMethods {
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
