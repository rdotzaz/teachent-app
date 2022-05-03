import 'package:flutter/material.dart';
import 'package:teachent_app/common/enums.dart';
import 'package:teachent_app/common/enum_functions.dart';
import 'package:teachent_app/controller/controller.dart';
import 'package:teachent_app/model/db_objects/lesson.dart';
import 'package:teachent_app/model/db_objects/student.dart';
import 'package:teachent_app/model/db_objects/teacher.dart';
import 'package:teachent_app/view/pages/student_profile_page/student_profile_page.dart';
import 'package:teachent_app/view/pages/teacher_profile_page/teacher_profile_page.dart';

class LessonPageController extends BaseController {
  final Lesson lesson;
  final Teacher teacher;
  final Student student;
  final bool isTeacher;
  LessonPageController(this.lesson, this.teacher, this.student, this.isTeacher);

  String get date => lesson.date;
  String get userType => isTeacher ? 'Teacher' : 'Student';
  String get name => isTeacher ? teacher.name : student.name;
  String get status => lesson.status.stringValue;
  bool get isNotCancelled =>
      lesson.status == LessonStatus.open ||
      lesson.status == LessonStatus.finished;

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

  Future<void> goToProfilePage(BuildContext context) async {
    await Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => isTeacher
            ? TeacherProfilePage(teacher: teacher)
            : StudentProfilePage(student)));
  }

  void cancelLesson() {}
}
