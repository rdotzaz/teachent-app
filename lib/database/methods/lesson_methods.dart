import 'package:teachent_app/common/consts.dart';
import 'package:teachent_app/common/enums.dart';
import 'package:teachent_app/common/enum_functions.dart';
import 'package:teachent_app/common/firebase_enums.dart';
import 'package:teachent_app/database/adapters/firebase_adapter.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';
import 'package:teachent_app/model/db_objects/lesson.dart';

/// Methods to maintain Lesson object in database
mixin LessonDatabaseMethods {
  /// Get all lessons objects by [lessonDateIds]
  /// First retrieved all lessons with [lessonDateIds], afterwards
  /// filter lessons with specific status
  Future<Iterable<Lesson>> getLessonsByDates(
      List<KeyId> lessonDateIds, LessonStatus status) async {
    final lessons = <Lesson>[];
    for (final lessonDateId in lessonDateIds) {
      final response =
          await FirebaseRealTimeDatabaseAdapter.getObjectsByProperty(
              DatabaseObjectName.lessons, 'lessonDateId', lessonDateId);

      response.data.forEach((key, lessonValues) {
        if (lessonValues.isEmpty ||
            (lessonValues['status'] ?? -1) != status.value) {
          return;
        }
        lessons.add(Lesson.fromMap(key, lessonValues));
      });
    }
    return lessons;
  }

  /// Get available lessons from database based on [lessonDateId]
  Future<List<Lesson>> getLessonsByDate(KeyId lessonDateId) async {
    final lessons = <Lesson>[];
    final response = await FirebaseRealTimeDatabaseAdapter.getObjectsByProperty(
        DatabaseObjectName.lessons, 'lessonDateId', lessonDateId);
    response.data.forEach((key, lessonValues) {
      if (lessonValues.isEmpty) {
        return;
      }
      lessons.add(Lesson.fromMap(key, lessonValues));
    });
    return lessons;
  }

  /// Get lesson object based on [lessonId]
  Future<Lesson?> getLesson(KeyId lessonId) async {
    final response = await FirebaseRealTimeDatabaseAdapter.getObject(
        DatabaseObjectName.lessons, lessonId);
    if (response.status == FirebaseResponseStatus.failure) {
      return null;
    }
    return Lesson.fromMap(lessonId, response.data);
  }

  /// Add lesson object to database
  Future<KeyId> addLesson(Lesson lesson) async {
    final response =
        await FirebaseRealTimeDatabaseAdapter.addDatabaseObjectWithNewKey(
            DatabaseObjectName.lessons, lesson.toMap());
    return response.data;
  }

  /// Update lesson status with [lessonStatus]
  Future<void> updateLessonStatus(
      KeyId lessonId, LessonStatus lessonStatus) async {
    await FirebaseRealTimeDatabaseAdapter.updateField(
        DatabaseObjectName.lessons, lessonId, 'status', lessonStatus.value);
  }

  /// Update lesson property -> reportId
  Future<void> updateReportId(KeyId lessonId, KeyId reportId) async {
    await FirebaseRealTimeDatabaseAdapter.updateField(
        DatabaseObjectName.lessons, lessonId, 'reportId', reportId);
  }

  /// Return true if lesson with [lessonId] is open
  Future<bool> isLessonOpen(KeyId lessonId) async {
    if (lessonId.isEmpty) {
      return false;
    }

    final response = await FirebaseRealTimeDatabaseAdapter.getField(
        DatabaseObjectName.lessons, lessonId, 'status');
    if (response.status == FirebaseResponseStatus.failure) {
      return false;
    }
    final statusNum = response.data as int? ?? -1;
    return statusNum == LessonStatus.open.value;
  }
}
