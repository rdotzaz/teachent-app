import 'package:flutter/material.dart';
import 'package:teachent_app/controller/controller.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';
import 'package:teachent_app/model/db_objects/lesson.dart';
import 'package:teachent_app/model/db_objects/lesson_date.dart';
import 'package:teachent_app/model/db_objects/request.dart';
import 'package:teachent_app/model/db_objects/student.dart';
import 'package:teachent_app/model/db_objects/teacher.dart';
import 'package:teachent_app/model/objects/education_level.dart';
import 'package:teachent_app/model/objects/tool.dart';
import 'package:teachent_app/view/pages/lesson_date_creation_page/lesson_date_creation_page.dart';
import 'package:teachent_app/view/pages/search_page/teacher_search_page.dart';
import 'package:teachent_app/view/pages/settings_page/settings_page.dart';

class TeacherHomePageController extends BaseController {
  final KeyId userId;
  late Teacher? teacher;

  // TODO - Remove after testing
  // ---------------------------------------------------------------------
  final students = [
    Student('john', 'John Smith', EducationLevel('high school', true), [],
        ['abcde']),
    Student('adam', 'Adam Cooper', EducationLevel('high school', true), [],
        ['tufjf'])
  ];

  final lessonDate1 = LessonDate('abcde', 'kowalski', 'john', false, 'Monday',
      '12:00+60', true, 50, [Tool('Google Meet', true)], []);
  final lessonDate2 = LessonDate('bgnjd', 'kowalski', '', true, 'Tuesday',
      '13:00+60', true, 50, [Tool('Google Meet', true)], []);
  final lessonDate3 = LessonDate('tufjf', 'kowalski', 'adam', false,
      'Wednesday', '17:00+60', false, 50, [Tool('Microsoft Teams', true)], []);
  final lessonDate4 = LessonDate('bpgkr', 'kowalski', '', true, 'Friday',
      '11:00+60', true, 50, [Tool('Google Meet', true)], []);
  final lessonDate5 = LessonDate('pohoo', 'kowalski', 'john', false, 'Thursday',
      '16:00+60', true, 50, [Tool('Google Meet', true)], []);

  final lessons = [
    Lesson('abcde', 'kowalski', 'john', '04-04-2022', true, false, []),
    Lesson('tufjf', 'kowalski', 'adam', '06-04-2022', true, false, []),
    Lesson('pohoo', 'kowalski', 'john', '07-04-2022', true, false, [])
  ];

  final requests = <Request>[];
  final lessonDates = <LessonDate>[];

  // ----------------------------------------------------------------------

  void Function() refresh;
  TeacherHomePageController(this.userId, this.refresh);

  @override
  Future<void> init() async {
    final possibleTeacher = await dataManager.database.getTeacher(userId);
    if (possibleTeacher == null) {
      // TODO - Raise error
      print('ERROR: Teacher not found');
      return;
    }
    print('After getTeacher');
    teacher = possibleTeacher;
  }

  String get searchName => 'Search students';
  String get teacherName => teacher?.name ?? '';
  bool get areLessons => lessons.isNotEmpty;
  bool get areStudents => students.isNotEmpty;
  bool get areRequests => requests.isNotEmpty;
  int get freeDates => lessonDates.length;
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
    final wasRequestAdded = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => LessonDateCreationPage(teacher!)));
    if (wasRequestAdded != null) {
      refresh();
    }
  }
}
