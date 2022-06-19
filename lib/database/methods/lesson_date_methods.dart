import 'package:teachent_app/common/consts.dart';
import 'package:teachent_app/common/date.dart';
import 'package:teachent_app/common/enum_functions.dart';
import 'package:teachent_app/common/enums.dart';
import 'package:teachent_app/common/firebase_enums.dart';
import 'package:teachent_app/database/adapters/firebase_adapter.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';
import 'package:teachent_app/model/db_objects/lesson_date.dart';

/// Methods to maintain LessonDate object in database
mixin LessonDateDatabaseMethods {
  /// Get lesson date by [lessonDateId]
  /// Return null if lesson date with [lessonDateId] does not exist
  Future<LessonDate?> getLessonDate(KeyId lessonDateId) async {
    final response = await FirebaseRealTimeDatabaseAdapter.getObject(
        DatabaseObjectName.lessonDates, lessonDateId);
    if (response.status == FirebaseResponseStatus.failure) {
      return null;
    }
    return LessonDate.fromMap(lessonDateId, response.data);
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
    final response =
        await FirebaseRealTimeDatabaseAdapter.addDatabaseObjectWithNewKey(
            DatabaseObjectName.lessonDates, lessonDate.toMap());
    return response.data;
  }

  /// Update current date with [newDate] for lesson date by [lessonDateId]
  Future<void> changeLessonDate(KeyId lessonDateId, DateTime newDate) async {
    await FirebaseRealTimeDatabaseAdapter.updateField(
        DatabaseObjectName.lessonDates,
        lessonDateId,
        'date',
        DateFormatter.getString(newDate));
  }

  /// Assing [studentId] to lesson date (cooperation) with [lessonDateId]
  Future<void> assignStudentToLessonDate(
      KeyId lessonDateId, KeyId studentId) async {
    await FirebaseRealTimeDatabaseAdapter.updateField(
        DatabaseObjectName.lessonDates, lessonDateId, 'studentId', studentId);
  }

  /// Change lesson date (cooperation) status to [status]
  Future<void> changeLessonDateStatus(
      KeyId lessonDateId, LessonDateStatus status) async {
    await FirebaseRealTimeDatabaseAdapter.updateField(
        DatabaseObjectName.lessonDates, lessonDateId, 'status', status.value);
  }

  /// Return true if cooperation is free
  Future<bool> isLessonDateFree(KeyId lessonDateId) async {
    if (lessonDateId.isEmpty) {
      return false;
    }

    final response = await FirebaseRealTimeDatabaseAdapter.getField(
        DatabaseObjectName.lessonDates, lessonDateId, 'status');
    if (response.status == FirebaseResponseStatus.failure) {
      return false;
    }
    final status = response.data as int? ?? -1;
    return status == LessonDateStatus.free.value;
  }
}
