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

/// Helper class for [ReportCreationPageController]
class LessonEntity {
  final Lesson lesson;
  final LessonDate lessonDate;
  final Student student;

  const LessonEntity(this.lesson, this.lessonDate, this.student);
}

/// Controller for report creation page
class ReportCreationPageController extends BaseController {
  final void Function() refresh;
  final List<KeyId> lessonDateIds;
  final Map<String, LessonEntity> lessonMap = {};
  ReportCreationPageController(this.refresh, this.lessonDateIds);

  String? selectedMapKey;
  String title = '';
  String description = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Future<void> init() async {
    final foundLessons = await dataManager.database
        .getLessonsByDates(lessonDateIds, LessonStatus.open);
    for (final lesson in foundLessons) {
      final lessonDate =
          await dataManager.database.getLessonDate(lesson.lessonDateId);
      final student = await dataManager.database.getStudent(lesson.studentId);
      if (student == null || lessonDate == null) {
        continue;
      }
      final entity = LessonEntity(lesson, lessonDate, student);
      lessonMap[_lessonString(entity)] = entity;
    }
  }

  /// Returns true if there are any lessons for which report can be created
  bool get hasLessons => lessonMap.isNotEmpty;
  /// Returns true if lesson has been selected by user
  bool get isLessonSelected => selectedMapKey != null;
  /// Returns default value in lesson dropdown menu if no lessons were selected.
  /// Otherwise returns selected lesson string representation
  String get initialLessonValue =>
      selectedMapKey == null ? '-- Select lesson --' : selectedMapKey!;
  List<String> get lessonItems {
    final items = ['-- Select lesson --'];
    if (lessonMap.isNotEmpty) {
      items.addAll(lessonMap.keys.toList());
    }
    return items;
  }

  /// Key for report creation form
  GlobalKey<FormState> get formKey => _formKey;

  String _lessonString(LessonEntity entity) =>
      '${DateFormatter.getString(entity.lesson.date)}, ${entity.student.name}';

  /// Set new [value] in [selectedMapKey]
  void selectLessonValue(String? value) {
    selectedMapKey = value ?? '';
    refresh();
  }

  /// Set new [value] for description property
  void setDescription(String? value) {
    description = value ?? '';
  }

  /// Set new [value] for title property
  void setTitle(String? value) {
    title = value ?? '';
  }

  /// Validates [value] as new title.
  /// If validation fails, then null returned
  /// Otherwise error message returns
  String? validateTitle(String? value) {
    return value?.isEmpty ?? true ? 'Title cannot be null' : null;
  }

  /// Methods triggers ReportManager and LessonManager to save report based on user data.
  /// Checks if validation passes. If not shows bottom sheet with error message
  void saveReport(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      assert(lessonMap.containsKey(selectedMapKey));

      final lessonDate = lessonMap[selectedMapKey]!.lessonDate;
      final lesson = lessonMap[selectedMapKey]!.lesson;
      await ReportManager.create(dataManager, lesson, title, description);
      await LessonManager.markLessonAsDone(dataManager, lesson);

      if (lessonDate.cycleType != CycleType.single) {
        await LessonManager.createNextLesson(dataManager, lessonDate, lesson);
      }
      await showSuccessMessageAsync(context, 'Report created');
      Navigator.of(context).pop();
      return;
    }
    showErrorMessage(context, 'Validation error');
  }
}
