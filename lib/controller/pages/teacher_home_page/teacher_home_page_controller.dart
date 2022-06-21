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

  /// Returns true if [ListPage] is currently displayed page
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

  /// Method retreives all assigned to [teacher] lesson objects from database
  /// Add to [lessons] list only open lessons
  Future<void> _initLessons() async {
    lessons.clear();
    final foundLessons = await dataManager.database
        .getLessonsByDates(teacher?.lessonDates ?? [], LessonStatus.open);
    lessons.addAll(foundLessons);
  }

  /// Method retreives all students with [teacher]'s lesson date object assigned
  Future<void> _initStudents() async {
    students.clear();
    final foundStudents = await dataManager.database
        .getStudentsByDates(teacher?.lessonDates ?? []);
    students.addAll(foundStudents);
  }

  /// Method retrives all lesson date (cooperation) objects based on lesson date ids from [teacher] object
  Future<void> _initDates() async {
    lessonDates.clear();
    final foundLessonDates =
        await dataManager.database.getLessonDates(teacher?.lessonDates ?? []);
    lessonDates.addAll(foundLessonDates);
  }

  /// Method retreives all requests based on request ids from [teacher] object
  Future<void> _initRequests() async {
    requests.clear();
    final foundRequests =
        await dataManager.database.getRequests(teacher?.requests ?? []);
    requests.addAll(foundRequests);
  }

  /// Get search bar title
  String get searchName => 'Search students';

  /// Get teacher name
  String get teacherName => teacher?.name ?? '';

  /// Return true if lessons found in database
  bool get areLessons => lessons.isNotEmpty;

  /// Return true if students found in database
  bool get areStudents => students.isNotEmpty;

  /// Return true if requests found in database
  bool get areRequests => requests.isNotEmpty;

  /// Return true if lesson dates found in database
  bool get areDates => lessonDates.isNotEmpty;

  /// Return student name based on given [studentId]
  String getStudentName(String studentId) {
    final student =
        students.firstWhere((student) => student.userId == studentId);
    return student.name;
  }

  /// Return status information visible on the lesson date item
  String getLessonDateStatus(LessonDate lessonDate) {
    if (lessonDate.isFree) {
      return 'Waiting for cooperator';
    }
    return lessonDate.studentId.isEmpty ? 'Cooperation cancelled' : 'Cooperation finished';
  }

  /// Method triggers TeacherSearchPage
  void goToSearchPage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => TeacherSearchPage()));
  }

  /// Method triggers SettingsPage
  void goToSettingsPage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => SettingsPage(userId: userId)));
  }

  /// Method triggers LessonDateCreationPage
  Future<void> goToLessonDateCreationPage(BuildContext context) async {
    final wasRequestAdded = await Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => LessonDateCreationPage(teacher!)));
    if (wasRequestAdded != null && !isMoreView) {
      refresh();
    }
  }

  /// Method triggers TeacherRequestPage for request with [requestIndex] from [requests] list
  Future<void> goToRequestPage(BuildContext context, int requestIndex) async {
    final request = requests[requestIndex];

    await Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => TeacherRequestPage(
            request: request, teacherId: teacher?.userId ?? '')));
    if (!isMoreView) {
      refresh();
    }
  }

  /// Method triggers StudentProfilePage for student with [studentIndex] from [students] list
  Future<void> goToStudentProfile(
      BuildContext context, int studentIndex) async {
    final student = students[studentIndex];

    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => StudentProfilePage(student)));
    if (!isMoreView) {
      refresh();
    }
  }

  /// Method triggers LessonPage for lesson with [lessonIndex] from [lessons] list
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

  /// Method triggers ReportCreationPage
  Future<void> goToReportPage(BuildContext context) async {
    await Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => ReportCreationPage(
            lessonDateIds:
                lessonDates.map((date) => date.lessonDateId).toList())));
    if (!isMoreView) {
      refresh();
    }
  }

  /// Method triggers LessonDatePage for lesson date with [dateIndex] from [lessonDates] list
  Future<void> goToLessonDatePage(BuildContext context, int dateIndex) async {
    await Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => LessonDatePage(lessonDates[dateIndex], true)));
    if (!isMoreView) {
      refresh();
    }
  }

  /// Method triggers ListPage for [lessons]
  /// Also [itemBuilder] allows to build and display item which represent single lesson object
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

  /// Method triggers ListPage for [students]
  /// Also [itemBuilder] allows to build and display item which represent single student object
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

  /// Method triggers ListPage for [lessonDates]
  /// Also [itemBuilder] allows to build and display item which represent single lesson date object
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

  /// Method triggers ListPage for [requests]
  /// Also [itemBuilder] allows to build and display item which represent single request object
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
