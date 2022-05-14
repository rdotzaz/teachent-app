import 'package:flutter/material.dart';
import 'package:teachent_app/common/enums.dart';
import 'package:teachent_app/common/date.dart';
import 'package:teachent_app/controller/controller.dart';
import 'package:teachent_app/controller/managers/lesson_manager.dart';
import 'package:teachent_app/controller/managers/report_manager.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';
import 'package:teachent_app/model/db_objects/lesson.dart';
import 'package:teachent_app/model/db_objects/lesson_date.dart';
import 'package:teachent_app/model/db_objects/student.dart';
import 'package:teachent_app/view/widgets/status_bottom_sheet.dart';

class LessonEntity {
  final Lesson lesson;
  final LessonDate lessonDate;
  final Student student;

  const LessonEntity(this.lesson, this.lessonDate, this.student);
}

class ReportCreationPageController extends BaseController {
  final void Function() refresh;
  final List<KeyId> lessonDateIds;
  final Map<String, LessonEntity> lessonMap = {};
  ReportCreationPageController(this.refresh, this.lessonDateIds);

  String? selectedMapKey;
  String title = '';
  String description = '';
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Future<void> init() async {
    final foundLessons = await dataManager.database
        .getLessonsByDates(lessonDateIds, LessonStatus.open);
    for (final lesson in foundLessons) {
      final lessonDate =
          await dataManager.database.getLessonDate(lesson.lessonDateId);
      final student = await dataManager.database.getStudent(lesson.studentId);
      if (student == null || lessonDate == null) {
        print(
            'No student ${lesson.studentId} or lessondate ${lesson.lessonDateId} found');
        continue;
      }
      final entity = LessonEntity(lesson, lessonDate, student);
      lessonMap[_lessonString(entity)] = entity;
    }
  }

  bool get hasLessons => lessonMap.isNotEmpty;
  bool get isLessonSelected => selectedMapKey != null;
  String get initialLessonValue =>
      selectedMapKey == null ? '-- Select lesson --' : selectedMapKey!;
  List<String> get lessonItems {
    final items = ['-- Select lesson --'];
    if (lessonMap.isNotEmpty) {
      items.addAll(lessonMap.keys.toList());
    }
    return items;
  }

  GlobalKey<FormState> get formKey => _formKey;

  String _lessonString(LessonEntity entity) =>
      '${DateFormatter.getString(entity.lesson.date)}, ${entity.student.name}';

  void selectLessonValue(String? value) {
    selectedMapKey = value ?? '';
    refresh();
  }

  void setDescription(String? value) {
    description = value ?? '';
  }

  void setTitle(String? value) {
    title = value ?? '';
  }

  String? validateTitle(String? value) {
    return value?.isEmpty ?? true ? 'Title cannot be null' : null;
  }

  void saveReport(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      assert(lessonMap.containsKey(selectedMapKey));
      await ReportManager.create(
          dataManager, lessonMap[selectedMapKey]!.lesson, title, description);
      await LessonManager.markLessonAsDone(
          dataManager, lessonMap[selectedMapKey]!.lesson);
      await LessonManager.createNextLesson(
          dataManager,
          lessonMap[selectedMapKey]!.lessonDate,
          lessonMap[selectedMapKey]!.lesson);
      await showSuccessMessageAsync(context, 'Report created');
      Navigator.of(context).pop();
      return;
    }
    showErrorMessage(context, 'Validation error');
  }
}
