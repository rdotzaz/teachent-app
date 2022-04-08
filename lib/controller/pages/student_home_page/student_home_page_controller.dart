import 'package:flutter/material.dart';
import 'package:teachent_app/controller/controller.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';
import 'package:teachent_app/model/db_objects/lesson.dart';
import 'package:teachent_app/model/db_objects/lesson_date.dart';
import 'package:teachent_app/model/db_objects/student.dart';
import 'package:teachent_app/model/db_objects/teacher.dart';
import 'package:teachent_app/model/objects/tool.dart';
import 'package:teachent_app/view/pages/teacher_search_page/student_search_page.dart';

/// Controller for Student Home Page
class StudentHomePageController extends BaseController {
  final KeyId userId;
  Student? student;

  StudentHomePageController(this.userId);

  // TODO -- Only for testing
  final teachers = [
    Teacher(
        'kowalski', 'Jan Kowalski', '', [], [], [], -1, [], ['abcde', 'pohoo'])
  ];

  final lessonDate1 = LessonDate('abcde', 'kowalski', 'john', false, 'Monday',
      '12:00+60', true, 50, [Tool('Google Meet', true)], []);
  final lessonDate2 = LessonDate('pohoo', 'kowalski', 'john', false, 'Thursday',
      '16:00+60', true, 50, [Tool('Google Meet', true)], []);

  final lessons = [
    Lesson('abcde', 'kowalski', 'john', '04-04-2022', true, false, []),
    Lesson('pohoo', 'kowalski', 'john', '07-04-2022', true, false, [])
  ];

  final requests = [];

  // ------------------------------------------------------

  @override
  Future<void> init() async {
    final possibleStudent = await dataManager.database.getStudent(userId);
    if (possibleStudent == null) {
      // TODO - Raise error
      print('ERROR: Student not found');
      return;
    }
    student = possibleStudent;
  }

  String get studentName => student?.name ?? '';
  bool get areLessons => lessons.isNotEmpty;
  bool get areTeachers => teachers.isNotEmpty;
  bool get areRequests => requests.isNotEmpty;
  bool get areReports => false;

  String getTeacherName(String teacherId) {
    final teacher =
        teachers.firstWhere((teacher) => teacher.userId == teacherId);
    return teacher.name;
  }

  void goToSearchPage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => StudentSearchPage()));
  }
}
