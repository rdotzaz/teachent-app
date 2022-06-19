import 'package:teachent_app/common/data_manager.dart';
import 'package:teachent_app/common/enums.dart';
import 'package:teachent_app/model/db_objects/lesson_date.dart';

/// Class for lesson dates (cooperations) management
class LessonDateManager {
  /// Set [lessonDate] as free
  static Future<void> setDateAsFree(
      DataManager dataManager, LessonDate? lessonDate) async {
    await dataManager.database.changeLessonDateStatus(
        lessonDate?.lessonDateId ?? '', LessonDateStatus.free);
  }

  /// Set [lessonDate] as ongoing
  static Future<void> setDateAsNotFree(
      DataManager dataManager, LessonDate? lessonDate) async {
    await dataManager.database.changeLessonDateStatus(
        lessonDate?.lessonDateId ?? '', LessonDateStatus.ongoing);
  }

  /// Cancel [lessonDate] by user. It means cooperation will not be leaded by teacher.
  /// Also mark all open lessons as cancelled.
  static Future<void> cancelCooperation(
      DataManager dataManager, LessonDate lessonDate, bool isTeacher) async {
    await dataManager.database.changeLessonDateStatus(
        lessonDate.lessonDateId, LessonDateStatus.finished);
    final lessons =
        await dataManager.database.getLessonsByDate(lessonDate.lessonDateId);
    final openLessons =
        lessons.where((lesson) => lesson.status == LessonStatus.open);
    final newStatus = isTeacher
        ? LessonStatus.teacherCancelled
        : LessonStatus.studentCancelled;
    for (final openLesson in openLessons) {
      await dataManager.database
          .updateLessonStatus(openLesson.lessonId, newStatus);
    }
  }
}
