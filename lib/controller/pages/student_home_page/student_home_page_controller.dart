import 'package:flutter/material.dart';
import 'package:teachent_app/common/enums.dart';
import 'package:teachent_app/controller/controller.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';
import 'package:teachent_app/model/db_objects/lesson.dart';
import 'package:teachent_app/model/db_objects/lesson_date.dart';
import 'package:teachent_app/model/db_objects/request.dart';
import 'package:teachent_app/model/db_objects/student.dart';
import 'package:teachent_app/model/db_objects/teacher.dart';
import 'package:teachent_app/view/pages/lesson_page/lesson_page.dart';
import 'package:teachent_app/view/pages/lesson_date/lesson_date_page.dart';
import 'package:teachent_app/view/pages/list_page/list_page.dart';
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
  final List<LessonDate> lessonDates = [];

  /// Returns true if [ListPage] is currently displayed page
  bool isMoreView = false;

  @override
  Future<void> init() async {
    final possibleStudent = await dataManager.database.getStudent(userId);
    assert(possibleStudent != null);
    student = possibleStudent;

    await initLessons();
    await initTeachers();
    await initRequests();
    await initLessonDates();
  }

  /// Method retreives all assigend to [student] lesson objects from database
  /// Add to [lessons] list only open lessons
  Future<void> initLessons() async {
    lessons.clear();
    final foundLessons = await dataManager.database
        .getLessonsByDates(student?.lessonDates ?? [], LessonStatus.open);
    lessons.addAll(foundLessons);
  }

  /// Method retreives all teachers with [student]'s lesson date objects assigend
  Future<void> initTeachers() async {
    teachers.clear();
    final foundTeachers = await dataManager.database
        .getTeachersByDates(student?.lessonDates ?? []);
    teachers.addAll(foundTeachers);
  }

  /// Method retreives all requests based on request ids from [student] object
  Future<void> initRequests() async {
    requests.clear();
    final foundRequests =
        await dataManager.database.getRequests(student?.requests ?? []);
    requests.addAll(foundRequests);
  }

  ///Method retreives all lesson date (cooperation) objects based on lesson date ids from [student] object
  Future<void> initLessonDates() async {
    lessonDates.clear();
    final foundLessonDates =
        await dataManager.database.getLessonDates(student?.lessonDates ?? []);
    lessonDates.addAll(foundLessonDates);
  }

  /// Return name of student
  String get studentName => student?.name ?? '';

  /// Retrun true if lessons found in database
  bool get areLessons => lessons.isNotEmpty;

  /// Retrun true if teachers found in database
  bool get areTeachers => teachers.isNotEmpty;

  /// Retrun true if requests found in database
  bool get areRequests => requests.isNotEmpty;

  /// Retrun true if lesson dates found in database
  bool get areDates => lessonDates.isNotEmpty;

  /// Return teacher name based on given [teacherId]
  String getTeacherName(String teacherId) {
    final teacher =
        teachers.firstWhere((teacher) => teacher.userId == teacherId);
    return teacher.name;
  }

  /// Method triggers StudentSearchPage
  Future<void> goToSearchPage(BuildContext context) async {
    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => StudentSearchPage(userId)));
    if (!isMoreView) {
      refresh();
    }
  }

  /// Method triggers SettingsPage
  void goToSettingsPage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => SettingsPage(userId: userId)));
  }

  /// Method triggers TeacherProfilePage based on teacher object with [index] from [teachers] list
  Future<void> goToTeacherProfile(BuildContext context, int index) async {
    await Navigator.of(context).push(MaterialPageRoute(
        builder: (_) =>
            TeacherProfilePage(teacher: teachers[index], studentId: userId)));
    if (!isMoreView) {
      refresh();
    }
  }

  /// Method triggers StudentRequestPage based on request object with [requestIndex] from [requests] list
  Future<void> goToRequestPage(BuildContext context, int requestIndex) async {
    final request = requests[requestIndex];

    await Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => StudentRequestPage(
            requestId: request.requestId, studentId: student?.userId ?? '')));
    if (!isMoreView) {
      refresh();
    }
  }

  /// Method triggers LessonPage based on lesson object with [lessonIndex] from [lessons] list
  Future<void> goToLessonPage(BuildContext context, int lessonIndex) async {
    final lesson = lessons[lessonIndex];
    final teacher = teachers.firstWhere((t) => t.userId == lesson.teacherId);

    await Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => LessonPage(
            lesson: lesson,
            teacher: teacher,
            student: student!,
            isTeacher: false)));
    if (!isMoreView) {
      refresh();
    }
  }

  /// Method triggers LessonDatePage based on lesson date object with [dateIndex] from [lessonDates] list
  Future<void> goToLessonDatePage(BuildContext context, int dateIndex) async {
    await Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => LessonDatePage(lessonDates[dateIndex], false)));
    if (!isMoreView) {
      refresh();
    }
  }

  /// Method triggers ListPage to show all assigend lessons to student
  Future<void> showMoreLessons(BuildContext context,
      Widget Function(BuildContext context, int index) itemBuilder) async {
    isMoreView = true;
    await Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => ListPage(
            title: 'Lessons',
            objects: lessons,
            elementBuilder: itemBuilder,
            init: init,
            color: Colors.red)));
    isMoreView = false;
  }

  /// Method triggers ListPage to show all teachers assigned to cooperations with student
  Future<void> showMoreTeachers(BuildContext context,
      Widget Function(BuildContext context, int index) itemBuilder) async {
    isMoreView = true;
    await Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => ListPage(
            title: 'Teachers',
            objects: teachers,
            elementBuilder: itemBuilder,
            init: init,
            color: Colors.red)));
    isMoreView = false;
  }

  /// Method triggers ListPage to show cooperations assigned to student
  Future<void> showMoreLessonDates(BuildContext context,
      Widget Function(BuildContext context, int index) itemBuilder) async {
    isMoreView = true;
    await Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => ListPage(
            title: 'Cooperations',
            objects: lessonDates,
            elementBuilder: itemBuilder,
            init: init,
            color: Colors.red)));
    isMoreView = false;
  }

  /// Method triggers ListPage to show all requests assigned to student
  Future<void> showMoreRequests(BuildContext context,
      Widget Function(BuildContext context, int index) itemBuilder) async {
    isMoreView = true;
    await Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => ListPage(
            title: 'Requests',
            objects: requests,
            elementBuilder: itemBuilder,
            init: init,
            color: Colors.red)));
    isMoreView = false;
  }
}
