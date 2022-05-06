import 'package:teachent_app/common/consts.dart';
import 'package:teachent_app/common/enums.dart';
import 'package:teachent_app/common/enum_functions.dart';
import 'package:teachent_app/database/adapters/firebase_adapter.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';
import 'package:teachent_app/model/db_objects/lesson.dart';

/// Methods to maintain Lesson object in database
mixin LessonDatabaseMethods {
  /// Get all lessons objects by [lessonDateIds]
  Future<Iterable<Lesson>> getLessonsByDates(List<KeyId> lessonDateIds) async {
    final lessons = <Lesson>[];
    for (final lessonDateId in lessonDateIds) {
      final lessonValues = await FirebaseRealTimeDatabaseAdapter.getObject(
          DatabaseObjectName.lessons, lessonDateId);

      if (lessonValues.isEmpty) {
        continue;
      }
      lessons.add(Lesson.fromMap(lessonDateId, lessonValues));
    }
    return lessons;
  }

  /// Add lesson object to database
  Future<KeyId> addLesson(Lesson lesson) async {
    final key =
        await FirebaseRealTimeDatabaseAdapter.addDatabaseObjectWithNewKey(
            DatabaseObjectName.lessons, lesson.toMap());

    if (key != DatabaseConsts.emptyKey) {
      print('LessonDate has been added');
    }
    return key;
  }

  Future<void> updateLessonStatus(KeyId lessonId, LessonStatus lessonStatus) async {
    await FirebaseRealTimeDatabaseAdapter.updateField(
        DatabaseObjectName.lessons, lessonId, 'status', lessonStatus.value);
  }
}
