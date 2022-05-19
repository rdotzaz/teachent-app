import 'package:teachent_app/common/consts.dart';
import 'package:teachent_app/common/enums.dart';
import 'package:teachent_app/common/enum_functions.dart';
import 'package:teachent_app/database/adapters/firebase_adapter.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';
import 'package:teachent_app/model/db_objects/lesson.dart';

/// Methods to maintain Lesson object in database
mixin LessonDatabaseMethods {
  /// Get all lessons objects by [lessonDateIds]
  /// Note: Poor performance due to "double" searching in database
  /// First retrieved all lessons with [lessonDateIds], afterwards
  /// filter lessons with specific status
  Future<Iterable<Lesson>> getLessonsByDates(
      List<KeyId> lessonDateIds, LessonStatus status) async {
    final lessons = <Lesson>[];
    for (final lessonDateId in lessonDateIds) {
      final lessonsValues =
          await FirebaseRealTimeDatabaseAdapter.getObjectsByProperty(
              DatabaseObjectName.lessons, 'lessonDateId', lessonDateId);

      lessonsValues.forEach((key, lessonValues) {
        if (lessonValues.isEmpty ||
            (lessonValues['status'] ?? -1) != status.value) {
          return;
        }
        lessons.add(Lesson.fromMap(key, lessonValues));
      });
    }
    return lessons;
  }

  Future<List<Lesson>> getLessonsByDate(KeyId lessonDateId) async {
    final lessons = <Lesson>[];
    final lessonsValues =
        await FirebaseRealTimeDatabaseAdapter.getObjectsByProperty(
            DatabaseObjectName.lessons, 'lessonDateId', lessonDateId);
    lessonsValues.forEach((key, lessonValues) {
      if (lessonValues.isEmpty) {
        return;
      }
      lessons.add(Lesson.fromMap(key, lessonValues));
    });
    return lessons;
  }

  /// Get lesson object based on [lessonId]
  Future<Lesson?> getLesson(KeyId lessonId) async {
    final lessonValues = await FirebaseRealTimeDatabaseAdapter.getObject(
        DatabaseObjectName.lessons, lessonId);
    if (lessonValues.isEmpty) {
      return null;
    }
    return Lesson.fromMap(lessonId, lessonValues);
  }

  /// Add lesson object to database
  Future<KeyId> addLesson(Lesson lesson) async {
    final key =
        await FirebaseRealTimeDatabaseAdapter.addDatabaseObjectWithNewKey(
            DatabaseObjectName.lessons, lesson.toMap());
    return key;
  }

  Future<void> updateLessonStatus(
      KeyId lessonId, LessonStatus lessonStatus) async {
    await FirebaseRealTimeDatabaseAdapter.updateField(
        DatabaseObjectName.lessons, lessonId, 'status', lessonStatus.value);
  }

  Future<void> updateReportId(KeyId lessonId, KeyId reportId) async {
    await FirebaseRealTimeDatabaseAdapter.updateField(
        DatabaseObjectName.lessons, lessonId, 'reportId', reportId);
  }
}
