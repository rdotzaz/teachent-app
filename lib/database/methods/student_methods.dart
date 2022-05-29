import 'package:teachent_app/common/firebase_enums.dart';
import 'package:teachent_app/database/adapters/firebase_adapter.dart';

import '../../common/consts.dart';
import '../../model/db_objects/db_object.dart';
import '../../model/db_objects/student.dart';

/// Methods to maintain Student object in database
mixin StudentDatabaseMethods {
  /// Add student to database
  Future<void> addStudent(Student student) async {
    await FirebaseRealTimeDatabaseAdapter.addDatabaseObject(
        DatabaseObjectName.students, student.key, student.toMap());
  }

  /// Returns Student object based on [userId]
  /// If object with [userId] does not exist in database, returns null
  Future<Student?> getStudent(KeyId userId) async {
    final response = await FirebaseRealTimeDatabaseAdapter.getObject(
        DatabaseObjectName.students, userId);
    if (response.status == FirebaseResponseStatus.failure) {
      return null;
    }

    return Student.fromMap(userId, response.data);
  }

  /// Returns list of students with matching pattern [name]
  Future<List<Student>> getStudentsByNamePart(String name) async {
    final response = await FirebaseRealTimeDatabaseAdapter.getObjectsByName(
        DatabaseObjectName.students, 'name', name);
    final students = <Student>[];
    response.data.forEach((login, studentValue) {
      final student =
          Student.fromMap(login, studentValue as Map<dynamic, dynamic>);
      students.add(student);
    });
    return students;
  }

  Future<void> addLessonDateKeyToStudent(
      KeyId studentId, KeyId lessonDateId) async {
    await FirebaseRealTimeDatabaseAdapter.updateField(
        DatabaseObjectName.students,
        studentId,
        DatabaseObjectName.lessonDates,
        {lessonDateId: true});
  }

  Future<Iterable<Student>> getStudentsByDates(
      List<KeyId> lessonDateIds) async {
    final students = <KeyId, Student>{};
    for (final lessonDateId in lessonDateIds) {
      final response = await FirebaseRealTimeDatabaseAdapter.getForeignKey(
          DatabaseObjectName.lessonDates, lessonDateId, 'studentId');
      if (response.status == FirebaseResponseStatus.failure) {
        continue;
      }
      final student = await getStudent(response.data);
      if (student == null) {
        continue;
      }
      students[student.userId] = student;
    }
    return students.entries.map((e) => e.value).toList();
  }

  Future<void> addRequestIdToStudent(KeyId studentId, KeyId requestId) async {
    await FirebaseRealTimeDatabaseAdapter.updateField(
        DatabaseObjectName.students,
        studentId,
        DatabaseObjectName.requests,
        {requestId: true});
  }

  Future<void> addLessonDateIdToStudent(
      KeyId studentId, KeyId lessonDateId) async {
    await FirebaseRealTimeDatabaseAdapter.updateField(
        DatabaseObjectName.students,
        studentId,
        DatabaseObjectName.lessonDates,
        {lessonDateId: true});
  }

  Future<void> addReviewIdToStudent(KeyId studentId, KeyId reviewId) async {
    await FirebaseRealTimeDatabaseAdapter.updateField(
        DatabaseObjectName.students,
        studentId,
        DatabaseObjectName.reviews,
        {reviewId: true});
  }
}
