import 'package:flutter/material.dart';
import 'package:teachent_app/controller/controller.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';
import 'package:teachent_app/model/db_objects/lesson.dart';
import 'package:teachent_app/model/db_objects/request.dart';
import 'package:teachent_app/model/db_objects/student.dart';
import 'package:teachent_app/model/db_objects/teacher.dart';
import 'package:teachent_app/view/pages/search_page/student_search_page.dart';
import 'package:teachent_app/view/pages/settings_page/settings_page.dart';
import 'package:teachent_app/view/pages/teacher_profile_page/teacher_profile_page.dart';
import 'package:teachent_app/view/pages/student_request_page/student_request_page.dart';

/// Controller for Student Home Page
class StudentHomePageController extends BaseController {
  final KeyId userId;
  Student? student;
  final void Function() refresh;

  StudentHomePageController(this.userId, this.refresh);

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
    lessons.clear();
    final foundLessons = await dataManager.database
        .getLessonsByDates(student?.lessonDates ?? []);
    if (foundLessons.isEmpty) {
      print('No lessons found');
    }
    lessons.addAll(foundLessons);
  }

  Future<void> initTeachers() async {
    teachers.clear();
    final foundTeachers = await dataManager.database
        .getTeachersByDates(student?.lessonDates ?? []);
    if (foundTeachers.isEmpty) {
      print('No teachers found');
    }
    teachers.addAll(foundTeachers);
  }

  Future<void> initRequests() async {
    requests.clear();
    final foundRequests =
        await dataManager.database.getRequests(student?.requests ?? []);
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

  Future<void> goToSearchPage(BuildContext context) async {
    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => StudentSearchPage(userId)));
    refresh();
  }

  void goToSettingsPage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => SettingsPage(userId: userId)));
  }

  Future<void> goToTeacherProfile(BuildContext context, int index) async {
    await Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => TeacherProfilePage(teachers[index], userId)));
    refresh();
  }

  Future<void> goToRequestPage(BuildContext context, int requestIndex) async {
    final request = requests[requestIndex];

    await Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => StudentRequestPage(
            requestId: request.requestId, studentId: student?.userId ?? '')));
    refresh();
  }
}
