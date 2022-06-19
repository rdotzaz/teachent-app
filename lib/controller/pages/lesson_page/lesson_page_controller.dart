import 'package:flutter/material.dart';
import 'package:teachent_app/common/date.dart';
import 'package:teachent_app/common/enums.dart';
import 'package:teachent_app/common/enum_functions.dart';
import 'package:teachent_app/controller/controller.dart';
import 'package:teachent_app/controller/managers/lesson_manager.dart';
import 'package:teachent_app/model/db_objects/lesson.dart';
import 'package:teachent_app/model/db_objects/student.dart';
import 'package:teachent_app/model/db_objects/teacher.dart';
import 'package:teachent_app/view/pages/student_profile_page/student_profile_page.dart';
import 'package:teachent_app/view/pages/teacher_profile_page/teacher_profile_page.dart';
import 'package:teachent_app/view/widgets/status_bottom_sheet.dart';

/// Controller for lesson page
class LessonPageController extends BaseController {
  final Lesson lesson;
  final Teacher teacher;
  final Student student;
  final bool isTeacher;
  LessonPageController(this.lesson, this.teacher, this.student, this.isTeacher);

  String get date => DateFormatter.getString(lesson.date);
  String get userType => isTeacher ? 'Teacher' : 'Student';
  String get name => isTeacher ? teacher.name : student.name;
  String get status => lesson.status.stringValue;

  /// Returns true if lesson has not been cancelled yet
  bool get isNotCancelled =>
      lesson.status == LessonStatus.open ||
      lesson.status == LessonStatus.finished;

  /// Returns color for status bar
  Color getStatusColor() {
    final currentStatus = lesson.status;
    if (currentStatus == LessonStatus.open) {
      return Colors.blue;
    }
    if (currentStatus == LessonStatus.teacherCancelled ||
        currentStatus == LessonStatus.studentCancelled) {
      return Colors.red;
    }
    return Colors.green;
  }

  /// Methods trigger new page.
  /// If user has teacher profile, then TeacherProfilePage will be displayed.
  /// Otherwise StudentProfilePage.
  Future<void> goToProfilePage(BuildContext context) async {
    await Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => isTeacher
            ? TeacherProfilePage(teacher: teacher)
            : StudentProfilePage(student)));
  }

  /// Methods trigger LessonManager to cancel selected lesson.
  Future<void> cancelLesson(BuildContext context) async {
    final lessonDate =
        await dataManager.database.getLessonDate(lesson.lessonDateId);
    if (lessonDate == null) {
      return;
    }
    if (lesson.status != LessonStatus.open) {
      return;
    }
    if (!await dataManager.database.isLessonOpen(lesson.lessonId)) {
      showErrorMessage(context, 'Lesson has already been cancelled');
      return;
    }
    if (isTeacher) {
      await LessonManager.cancelLessonByTeacher(
          dataManager, lessonDate, lesson);
    } else {
      await LessonManager.cancelLessonByStudent(
          dataManager, lessonDate, lesson);
    }
    await showSuccessMessageAsync(context, 'Lesson has been cancelled');
    Navigator.of(context).pop();
  }
}
