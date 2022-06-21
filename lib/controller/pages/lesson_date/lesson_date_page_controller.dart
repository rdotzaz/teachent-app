import 'package:flutter/material.dart';
import 'package:teachent_app/common/date.dart';
import 'package:teachent_app/common/enum_functions.dart';
import 'package:teachent_app/common/enums.dart';
import 'package:teachent_app/controller/controller.dart';
import 'package:teachent_app/controller/managers/lesson_date_manager.dart';
import 'package:teachent_app/model/db_objects/lesson_date.dart';
import 'package:teachent_app/model/db_objects/lesson.dart';
import 'package:teachent_app/model/db_objects/report.dart';
import 'package:teachent_app/model/db_objects/teacher.dart';
import 'package:teachent_app/model/db_objects/student.dart';
import 'package:teachent_app/model/objects/place.dart';
import 'package:teachent_app/model/objects/tool.dart';
import 'package:teachent_app/view/widgets/status_bottom_sheet.dart';

/// Helper class for [LessonDatePageController]
class LessonEntity {
  final Lesson lesson;
  final Report? report;
  const LessonEntity(this.lesson, this.report);
}

/// Controller for lesson date page
class LessonDatePageController extends BaseController {
  final LessonDate lessonDate;
  final bool isTeacher;
  LessonDatePageController(this.lessonDate, this.isTeacher);

  late Teacher teacher;
  Student? student;
  final List<LessonEntity> lessonEntities = [];

  bool get isNotFree => !lessonDate.isFree;
  bool get isFinished => lessonDate.status == LessonDateStatus.finished;
  String get studentName => student?.name ?? '-';
  String get teacherName => teacher.name;
  String get cycleType => lessonDate.cycleType.stringValue;
  String get price => lessonDate.price.toString();
  String get startDate => DateFormatter.getString(lessonDate.date);
  List<Tool> get tools => lessonDate.tools;
  List<Place> get places => lessonDate.places;
  bool get hasTools => lessonDate.tools.isNotEmpty;
  bool get hasPlaces => lessonDate.places.isNotEmpty;
  bool get areLessons => lessonEntities.isNotEmpty;

  @override
  Future<void> init() async {
    lessonEntities.clear();
    final foundLessons =
        await dataManager.database.getLessonsByDate(lessonDate.lessonDateId);

    for (final lesson in foundLessons) {
      final report = await dataManager.database.getReport(lesson.reportId);
      lessonEntities.add(LessonEntity(lesson, report));
    }
    lessonEntities.sort((e1, e2) => e2.lesson.date.compareTo(e1.lesson.date));

    final foundStudent =
        await dataManager.database.getStudent(lessonDate.studentId);

    if (foundStudent != null) {
      student = foundStudent;
    }

    final foundTeacher =
        await dataManager.database.getTeacher(lessonDate.teacherId);

    if (foundTeacher == null) {
      return;
    }
    teacher = foundTeacher;
  }

  /// Method trigger [LessonDateManager] to cancel cooperation.
  /// [context] is required to show bottom sheet.
  void cancelCooperation(BuildContext context) async {
    await LessonDateManager.cancelCooperation(
        dataManager, lessonDate, isTeacher);
    await showSuccessMessageAsync(context, 'Cooperation cancelled');
    Navigator.of(context).pop();
  }
}
