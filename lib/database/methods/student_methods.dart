import 'package:teachent_app/database/adapters/firebase_adapter.dart';
import 'package:teachent_app/model/objects/education_level.dart';

import '../../common/consts.dart';
import '../../model/db_objects/db_object.dart';
import '../../model/db_objects/student.dart';

/// Methods to maintain Student object in database
mixin StudentDatabaseMethods {
  /// Add student to database
  Future<void> addStudent(Student student) async {
    print('Student');
    var wasAdded = await FirebaseRealTimeDatabaseAdapter.addDatabaseObject(
        DatabaseObjectName.students, student.key, student.toMap());
    return;
  }

  /// Returns newly created map object based on map object stored in [field]
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

  /// Returns Student object based on [userId]
  /// If object with [userId] does not exist in database, returns null
  Future<Student?> getStudent(KeyId userId) async {
    final studentValues = await FirebaseRealTimeDatabaseAdapter.getObject(
        DatabaseObjectName.students, userId);
    if (studentValues.isEmpty) {
      return null;
    }

    return Student.fromMap(userId, studentValues);
  }

  /// Returns list of students with matching pattern [name]
  Future<List<Student>> getStudentsByNamePart(String name) async {
    final studentValues =
        await FirebaseRealTimeDatabaseAdapter.getObjectsByName(
            DatabaseObjectName.students, 'name', name);
    final students = <Student>[];
    studentValues.forEach((login, studentValue) {
      final student =
          Student.fromMap(login, studentValue as Map<dynamic, dynamic>);
      students.add(student);
    });
    return students;
  }

  Future<void> addLessonDateKeyToStudent(
      KeyId studentId, KeyId lessonDateId) async {
    await FirebaseRealTimeDatabaseAdapter.addForeignKey(
        DatabaseObjectName.students,
        studentId,
        DatabaseObjectName.lessonDates,
        lessonDateId);
  }

  Future<Iterable<Student>> getStudentsByDates(
      List<KeyId> lessonDateIds) async {
    final students = <Student>[];
    for (final lessonDateId in lessonDateIds) {
      final studentId = await FirebaseRealTimeDatabaseAdapter.getForeignKey(
          DatabaseObjectName.lessonDates, lessonDateId, 'studentId');
      if (studentId == DatabaseConsts.emptyKey) {
        continue;
      }
      final student = await getStudent(studentId);
      if (student == null) {
        continue;
      }
      students.add(student);
    }
    return students;
  }

  Future<void> addRequestIdToStudent(KeyId studentId, KeyId requestId) async {
    await FirebaseRealTimeDatabaseAdapter.addForeignKey(
        DatabaseObjectName.students,
        studentId,
        DatabaseObjectName.requests,
        requestId);
  }
}
