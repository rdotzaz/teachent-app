import 'package:teachent_app/database/adapters/firebase_adapter.dart';

import '../../common/consts.dart';
import '../../model/db_objects/db_object.dart';
import '../../model/db_objects/teacher.dart';

mixin TeacherDatabaseMethods {
  Future<void> addTeacher(Teacher teacher) async {
    print('Teacher');
    var wasAdded = await FirebaseRealTimeDatabaseAdapter.addDatabaseObject(
      DatabaseObjectName.teachers, teacher.key, teacher.toMap());
    return;
  }

  void update(KeyId teacherId) {}

  void deleteTeacher(KeyId teacherId) {}
}
