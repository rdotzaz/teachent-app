import 'package:flutter/material.dart';
import 'package:teachent_app/common/enums.dart';
import 'package:teachent_app/controller/controller.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';
import 'package:teachent_app/model/db_objects/lesson.dart';
import 'package:teachent_app/model/db_objects/lesson_date.dart';
import 'package:teachent_app/model/db_objects/request.dart';
import 'package:teachent_app/model/db_objects/student.dart';
import 'package:teachent_app/model/db_objects/teacher.dart';
import 'package:teachent_app/view/pages/lesson_date_creation_page/lesson_date_creation_page.dart';
import 'package:teachent_app/view/pages/lesson_date/lesson_date_page.dart';
import 'package:teachent_app/view/pages/lesson_page/lesson_page.dart';
import 'package:teachent_app/view/pages/list_page/list_page.dart';
import 'package:teachent_app/view/pages/report_creation_page/report_creation_page.dart';
import 'package:teachent_app/view/pages/search_page/teacher_search_page.dart';
import 'package:teachent_app/view/pages/settings_page/settings_page.dart';
import 'package:teachent_app/view/pages/teacher_request_page/teacher_request_page.dart';
import 'package:teachent_app/view/pages/student_profile_page/student_profile_page.dart';

/// Controller for Teacher Home Page
class TeacherHomePageController extends BaseController {
  final KeyId userId;
  Teacher? teacher;

  final List<Lesson> lessons = [];
  final List<LessonDate> lessonDates = [];
  final List<Student> students = [];
  final List<Request> requests = [];

  final void Function() refresh;
  TeacherHomePageController(this.userId, this.refresh);

  bool isMoreView = false;

  @override
  Future<void> init() async {
    final possibleTeacher = await dataManager.database.getTeacher(userId);
    assert(possibleTeacher != null);
    teacher = possibleTeacher;

    await _initLessons();
    await _initStudents();
    await _initDates();
    await _initRequests();
  }

  Future<void> _initLessons() async {
    lessons.clear();
    final foundLessons = await dataManager.database
        .getLessonsByDates(teacher?.lessonDates ?? [], LessonStatus.open);
    lessons.addAll(foundLessons);
  }

  Future<void> _initStudents() async {
    students.clear();
    final foundStudents = await dataManager.database
        .getStudentsByDates(teacher?.lessonDates ?? []);
    students.addAll(foundStudents);
  }

  Future<void> _initDates() async {
    lessonDates.clear();
    final foundLessonDates =
        await dataManager.database.getLessonDates(teacher?.lessonDates ?? []);
    lessonDates.addAll(foundLessonDates);
  }

  Future<void> _initRequests() async {
    requests.clear();
    final foundRequests =
        await dataManager.database.getRequests(teacher?.requests ?? []);
    requests.addAll(foundRequests);
  }

  String get searchName => 'Search students';
  String get teacherName => teacher?.name ?? '';
  bool get areLessons => lessons.isNotEmpty;
  bool get areStudents => students.isNotEmpty;
  bool get areRequests => requests.isNotEmpty;
  bool get areDates => lessonDates.isNotEmpty;

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
    if (wasRequestAdded != null && !isMoreView) {
      refresh();
    }
  }

  Future<void> goToRequestPage(BuildContext context, int requestIndex) async {
    final request = requests[requestIndex];

    await Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => TeacherRequestPage(
            request: request, teacherId: teacher?.userId ?? '')));
    if (!isMoreView) {
      refresh();
    }
  }

  Future<void> goToStudentProfile(
      BuildContext context, int studentIndex) async {
    final student = students[studentIndex];

    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => StudentProfilePage(student)));
    if (!isMoreView) {
      refresh();
    }
  }

  Future<void> goToLessonPage(BuildContext context, int lessonIndex) async {
    final lesson = lessons[lessonIndex];
    final student = students.firstWhere((s) => s.userId == lesson.studentId);

    await Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => LessonPage(
            lesson: lesson,
            teacher: teacher!,
            student: student,
            isTeacher: true)));
    if (!isMoreView) {
      refresh();
    }
  }

  Future<void> goToReportPage(BuildContext context) async {
    await Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => ReportCreationPage(
            lessonDateIds:
                lessonDates.map((date) => date.lessonDateId).toList())));
    if (!isMoreView) {
      refresh();
    }
  }

  Future<void> goToLessonDatePage(BuildContext context, int dateIndex) async {
    await Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => LessonDatePage(lessonDates[dateIndex], true)));
    if (!isMoreView) {
      refresh();
    }
  }

  Future<void> showMoreLessons(BuildContext context,
      Widget Function(BuildContext context, int index) itemBuilder) async {
    isMoreView = true;
    await Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => ListPage(
            title: 'Lessons',
            objects: lessons,
            elementBuilder: itemBuilder,
            init: init,
            color: Colors.blue)));
    isMoreView = false;
  }

  Future<void> showMoreStudents(BuildContext context,
      Widget Function(BuildContext context, int index) itemBuilder) async {
    isMoreView = true;
    await Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => ListPage(
            title: 'Students',
            objects: students,
            elementBuilder: itemBuilder,
            init: init,
            color: Colors.blue)));
    isMoreView = false;
  }

  Future<void> showMoreLessonDates(BuildContext context,
      Widget Function(BuildContext context, int index) itemBuilder) async {
    isMoreView = true;
    await Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => ListPage(
            title: 'Cooperations',
            objects: lessonDates,
            elementBuilder: itemBuilder,
            init: init,
            color: Colors.blue)));
    isMoreView = false;
  }

  Future<void> showMoreRequests(BuildContext context,
      Widget Function(BuildContext context, int index) itemBuilder) async {
    isMoreView = true;
    await Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => ListPage(
            title: 'Requests',
            objects: requests,
            elementBuilder: itemBuilder,
            init: init,
            color: Colors.blue)));
    isMoreView = false;
  }
}
