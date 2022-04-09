import 'package:teachent_app/database/adapters/firebase_adapter.dart';
import 'package:teachent_app/database/database.dart';
import 'package:teachent_app/model/objects/education_level.dart';

import '../../common/consts.dart';
import '../../model/db_objects/db_object.dart';
import '../../model/db_objects/student.dart';

mixin StudentDatabaseMethods on IDatabase {
  Future<void> addStudent(Student student) async {
    print('Student');
    var wasAdded = await FirebaseRealTimeDatabaseAdapter.addDatabaseObject(
        fbReference!,
        DatabaseObjectName.students,
        student.key,
        student.toMap());
    return;
  }

  void update(KeyId studentId) {}

  void deleteStudent(KeyId studentId) {}

  Map<String, dynamic> _getMapFromField(
      Map<dynamic, dynamic> values, String field) {
    if (values[field] == null) {
      return {};
    }
    return {
      for (var entry in (values[field] as Map<dynamic, dynamic>).entries)
        (entry.key as String): true
    };
  }

  Future<Student?> getStudent(KeyId userId) async {
    final studentValues = await FirebaseRealTimeDatabaseAdapter.getObject(
        fbReference!, DatabaseObjectName.students, userId);
    if (studentValues.isEmpty) {
      return null;
    }

    print('[Students methods] Student found');
    final requestIds = _getMapFromField(studentValues, 'requests');
    print('Requests: $requestIds');
    final requestList = requestIds.entries.map((id) => id.toString()).toList();

    final lessonDateIds = _getMapFromField(studentValues, 'lessonDates');
    print('Dates: $lessonDateIds');
    final lessonDateList =
        lessonDateIds.entries.map((id) => id.toString()).toList();

    return Student(
        userId,
        studentValues['name'] ?? '',
        EducationLevel(studentValues['educationLevel'] ?? '', true),
        requestList,
        lessonDateList);
  }

  void _addStudentToList(String login, Map values, List<Student> students) {
    students.add(Student.onlyKeyName(login, values['name'] ?? '',
        EducationLevel(values['educationLevel'] ?? '', true)));
  }

  Future<List<Student>> getStudentsByNamePart(String name) async {
    final studentValues =
        await FirebaseRealTimeDatabaseAdapter.getObjectsByName(
            fbReference!, DatabaseObjectName.students, 'name', name);
    final students = <Student>[];
    studentValues.forEach((login, studentValue) => _addStudentToList(
        login, studentValue as Map<dynamic, dynamic>, students));
    return students;
  }
}
