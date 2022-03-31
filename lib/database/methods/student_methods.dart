import 'package:teachent_app/database/adapters/firebase_adapter.dart';

import '../../common/consts.dart';
import '../../model/db_objects/db_object.dart';
import '../../model/db_objects/student.dart';

mixin StudentDatabaseMethods {
  Future<void> addStudent(Student student) async {
    print('Student');
    var wasAdded = await FirebaseRealTimeDatabaseAdapter.addDatabaseObject(
      DatabaseObjectName.students, student.key, student.toMap());
    return;
  }

  void update(KeyId studentId) {}

  void deleteStudent(KeyId studentId) {}
}
