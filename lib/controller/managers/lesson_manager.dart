import 'package:teachent_app/common/consts.dart';
import 'package:teachent_app/common/data_manager.dart';
import 'package:teachent_app/common/enums.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';
import 'package:teachent_app/model/db_objects/lesson.dart';
import 'package:teachent_app/model/db_objects/lesson_date.dart';

import 'lesson_date_manager.dart';

/// Class for lesson management
class LessonManager {
  /// Create first lesson within cooperation [lessonDate] and add student with [studentId] to cooperation.
  static Future<void> createFirst(
      DataManager dataManager, KeyId studentId, LessonDate lessonDate) async {
    final lesson = Lesson.noKey(lessonDate.lessonDateId, lessonDate.teacherId,
        studentId, lessonDate.date, LessonStatus.open, DatabaseConsts.emptyKey);
    await dataManager.database.addLesson(lesson);
  }

  /// Cancel [lesson] by teacher
  static Future<void> cancelLessonByTeacher(
      DataManager dataManager, LessonDate lessonDate, Lesson lesson) async {
    await LessonManager._cancelLesson(dataManager, lessonDate, lesson, true);
  }

  /// Cancel [lesson] by student
  static Future<void> cancelLessonByStudent(
      DataManager dataManager, LessonDate lessonDate, Lesson lesson) async {
    await LessonManager._cancelLesson(dataManager, lessonDate, lesson, false);
  }

  /// Create next lesson based on [lessonDate] if cooperation is cycled.
  static Future<void> createNextLesson(
      DataManager dataManager, LessonDate lessonDate, Lesson lesson) async {
    if (lessonDate.isCycled) {
      final newDate = LessonManager._getNewDate(lessonDate, lesson);
      final newLesson = Lesson.noKey(
          lessonDate.lessonDateId,
          lessonDate.teacherId,
          lessonDate.studentId,
          newDate,
          LessonStatus.open,
          DatabaseConsts.emptyKey);

      await dataManager.database.addLesson(newLesson);
    } else {
      await LessonDateManager.setDateAsFree(dataManager, lessonDate);
    }
  }

  /// Mark [lesson] as done.
  static Future<void> markLessonAsDone(
      DataManager dataManager, Lesson lesson) async {
    await dataManager.database
        .updateLessonStatus(lesson.lessonId, LessonStatus.finished);
  }

  static Future<void> _cancelLesson(DataManager dataManager,
      LessonDate lessonDate, Lesson lesson, bool isTeacher) async {
    await dataManager.database.updateLessonStatus(
        lesson.lessonId,
        isTeacher
            ? LessonStatus.teacherCancelled
            : LessonStatus.studentCancelled);
    await createNextLesson(dataManager, lessonDate, lesson);
  }

  static DateTime _getNewDate(LessonDate lessonDate, Lesson lesson) {
    int daysToAdd = 0;
    final cycleType = lessonDate.cycleType;
    assert(cycleType != CycleType.single);
    if (cycleType == CycleType.daily) {
      daysToAdd = 1;
    } else if (cycleType == CycleType.weekly) {
      daysToAdd = 7;
    } else if (cycleType == CycleType.biweekly) {
      daysToAdd = 14;
    } else if (cycleType == CycleType.monthly) {
      daysToAdd = 31;
    }
    return lesson.date.add(Duration(days: daysToAdd));
  }
}
