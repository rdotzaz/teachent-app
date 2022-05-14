import 'package:teachent_app/common/consts.dart';
import 'package:teachent_app/common/date.dart';
import 'package:teachent_app/database/adapters/firebase_adapter.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';
import 'package:teachent_app/model/db_objects/lesson_date.dart';

/// Methods to maintain LessonDate object in database
mixin LessonDateDatabaseMethods {
  /// Get lesson date by [lessonDateId]
  /// Return null if lesson date with [lessonDateId] does not exist
  Future<LessonDate?> getLessonDate(KeyId lessonDateId) async {
    final dateValues = await FirebaseRealTimeDatabaseAdapter.getObject(
        DatabaseObjectName.lessonDates, lessonDateId);
    if (dateValues.isEmpty) {
      return null;
    }
    return LessonDate.fromMap(lessonDateId, dateValues);
  }

  /// Get all lesson dates by [lessonDateIds]
  Future<List<LessonDate>> getLessonDates(List<KeyId> lessonDateIds) async {
    final dates = <LessonDate>[];
    for (final lessonDateId in lessonDateIds) {
      final lessonDate = await getLessonDate(lessonDateId);
      if (lessonDate == null) {
        continue;
      }
      dates.add(lessonDate);
    }
    return dates;
  }

  /// Add lesson date object to database
  Future<KeyId> addLessonDate(LessonDate lessonDate) async {
    final key =
        await FirebaseRealTimeDatabaseAdapter.addDatabaseObjectWithNewKey(
            DatabaseObjectName.lessonDates, lessonDate.toMap());

    if (key != DatabaseConsts.emptyKey) {
      print('LessonDate has been added');
    }
    //await FirebaseRealTimeDatabaseAdapter.addDatabaseObject(
    //    DatabaseObjectName.dateToReports, lessonDate.lessonDateId, {});
    return key;
  }

  /// Update current date with [newDate]t for lesson date by [lessonDateId]
  Future<void> changeLessonDate(KeyId lessonDateId, DateTime newDate) async {
    await FirebaseRealTimeDatabaseAdapter.updateField(
        DatabaseObjectName.lessonDates,
        lessonDateId,
        'date',
        DateFormatter.getString(newDate));
  }

  Future<void> assignStudentToLessonDate(
      KeyId lessonDateId, KeyId studentId) async {
    await FirebaseRealTimeDatabaseAdapter.updateField(
        DatabaseObjectName.lessonDates, lessonDateId, 'studentId', studentId);
  }

  Future<void> changeLessonDateIsFree(KeyId lessonDateId, bool isFree) async {
    await FirebaseRealTimeDatabaseAdapter.updateField(
        DatabaseObjectName.lessonDates, lessonDateId, 'isFree', isFree);
  }
}
