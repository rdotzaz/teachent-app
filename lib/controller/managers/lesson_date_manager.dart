import 'package:teachent_app/common/data_manager.dart';
import 'package:teachent_app/common/enums.dart';
import 'package:teachent_app/model/db_objects/lesson_date.dart';

class LessonDateManager {
  static Future<void> setDateAsFree(
      DataManager dataManager, LessonDate? lessonDate) async {
    await dataManager.database.changeLessonDateStatus(
        lessonDate?.lessonDateId ?? '', LessonDateStatus.free);
  }

  static Future<void> setDateAsNotFree(
      DataManager dataManager, LessonDate? lessonDate) async {
    await dataManager.database.changeLessonDateStatus(
        lessonDate?.lessonDateId ?? '', LessonDateStatus.ongoing);
  }

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
