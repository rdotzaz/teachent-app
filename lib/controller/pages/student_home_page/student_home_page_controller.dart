import 'package:flutter/material.dart';
import 'package:teachent_app/controller/controller.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';
import 'package:teachent_app/model/db_objects/lesson.dart';
import 'package:teachent_app/model/db_objects/lesson_date.dart';
import 'package:teachent_app/model/db_objects/request.dart';
import 'package:teachent_app/model/db_objects/student.dart';
import 'package:teachent_app/model/db_objects/teacher.dart';
import 'package:teachent_app/model/objects/tool.dart';
import 'package:teachent_app/model/objects/topic.dart';
import 'package:teachent_app/view/pages/search_page/student_search_page.dart';
import 'package:teachent_app/view/pages/settings_page/settings_page.dart';
import 'package:teachent_app/view/pages/teacher_profile_page/teacher_profile_page.dart';

class StudentHomePageController extends BaseController {
  final KeyId userId;
  Student? student;

  StudentHomePageController(this.userId);

  final List<Teacher> teachers = [];
  final List<Lesson> lessons = [];
  final List<Request> requests = [];

  @override
  Future<void> init() async {
    final possibleStudent = await dataManager.database.getStudent(userId);
    if (possibleStudent == null) {
      // TODO - Raise error
      print('ERROR: Student not found');
      return;
    }
    student = possibleStudent;

    await initLessons();
    await initTeachers();
    await initRequests();
  }

  Future<void> initLessons() async {
    final foundLessons = await dataManager.database.getLessonsByDates(student?.lessonDates ?? []);
    if (foundLessons.isEmpty) {
      print('No lessons found');
    }
    lessons.addAll(foundLessons);
  }

  Future<void> initTeachers() async {
    final foundTeachers = await dataManager.database.getTeachersByDates(student?.lessonDates ?? []);
    if (foundTeachers.isEmpty) {
      print('No teachers found');
    }
    teachers.addAll(foundTeachers);
  }

  Future<void> initRequests() async {
    final foundRequests = await dataManager.database.getRequests(student?.requests ?? []);
    if (foundRequests.isEmpty) {
      print('No requests found');
    }
    requests.addAll(foundRequests);
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
        .push(MaterialPageRoute(builder: (_) => StudentSearchPage(userId)));
  }

  void goToSettingsPage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => SettingsPage(userId: userId)));
  }

  void goToTeacherProfile(BuildContext context, int index) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => TeacherProfilePage(teachers[index], userId)));
  }
}
