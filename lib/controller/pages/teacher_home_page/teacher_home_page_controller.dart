import 'package:flutter/material.dart';
import 'package:teachent_app/controller/controller.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';
import 'package:teachent_app/model/db_objects/lesson.dart';
import 'package:teachent_app/model/db_objects/lesson_date.dart';
import 'package:teachent_app/model/db_objects/request.dart';
import 'package:teachent_app/model/db_objects/student.dart';
import 'package:teachent_app/model/db_objects/teacher.dart';
import 'package:teachent_app/view/pages/lesson_date_creation_page/lesson_date_creation_page.dart';
import 'package:teachent_app/view/pages/search_page/teacher_search_page.dart';
import 'package:teachent_app/view/pages/settings_page/settings_page.dart';

class TeacherHomePageController extends BaseController {
  final KeyId userId;
  Teacher? teacher;

  final List<Lesson> lessons = [];
  final List<LessonDate> lessonDates = [];
  final List<Student> students = [];
  final List<Request> requests = [];

  void Function() refresh;
  TeacherHomePageController(this.userId, this.refresh);

  @override
  Future<void> init() async {
    print('Before getTeacher');
    final possibleTeacher = await dataManager.database.getTeacher(userId);
    print('After getTeacher');
    if (possibleTeacher == null) {
      // TODO - Raise error
      print('ERROR: Teacher not found');
      return;
    }
    teacher = possibleTeacher;

    await _initLessons();
    await _initStudents();
    await _initDates();
  }

  Future<void> _initLessons() async {
    lessons.clear();
    final foundLessons = await dataManager.database
        .getLessonsByDates(teacher?.lessonDates ?? []);
    if (foundLessons.isEmpty) {
      print('No lessons found');
    }
    lessons.addAll(foundLessons);
  }

  Future<void> _initStudents() async {
    students.clear();
    final foundStudents = await dataManager.database
        .getStudentsByDates(teacher?.lessonDates ?? []);
    if (foundStudents.isEmpty) {
      print('No students found');
    }
    students.addAll(foundStudents);
  }

  Future<void> _initDates() async {
    lessonDates.clear();
    final foundLessonDates =
        await dataManager.database.getLessonDates(teacher?.lessonDates ?? []);
    if (foundLessonDates.isEmpty) {
      print('No dates found');
    }
    lessonDates.addAll(foundLessonDates);
    print('Date size: ${lessonDates.length}');
  }

  String get searchName => 'Search students';
  String get teacherName => teacher?.name ?? '';
  bool get areLessons => lessons.isNotEmpty;
  bool get areStudents => students.isNotEmpty;
  bool get areRequests => requests.isNotEmpty;
  int get freeDates => lessonDates.where((d) => d.isFree).length;
  bool get areReports => false;

  String getStudentName(String studentId) {
    final student =
        students.firstWhere((student) => student.userId == studentId);
    return student.name;
  }

  void goToSearchPage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => TeacherSearchPage()));
  }

  void goToSettingsPage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => SettingsPage(userId: userId)));
  }

  Future<void> goToLessonPageCreationPage(BuildContext context) async {
    final wasRequestAdded = await Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => LessonDateCreationPage(teacher!)));
    if (wasRequestAdded != null) {
      refresh();
    }
  }
}
