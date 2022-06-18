import 'package:flutter/material.dart';
import 'package:teachent_app/controller/controller.dart';
import 'package:teachent_app/controller/managers/review_manager.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';
import 'package:teachent_app/model/db_objects/student.dart';
import 'package:teachent_app/model/db_objects/teacher.dart';
import 'package:teachent_app/view/widgets/status_bottom_sheet.dart';

/// Controller for review creation page
class ReviewCreationPageController extends BaseController {
  final KeyId teacherId;
  final KeyId studentId;

  ReviewCreationPageController(this.teacherId, this.studentId);

  String title = '';
  String description = '';
  int rate = 5;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late Teacher? _teacher;
  late Student? _student;

  @override
  Future<void> init() async {
    final teacher = await dataManager.database.getTeacher(teacherId);
    final student = await dataManager.database.getStudent(studentId);

    if (teacher == null || student == null) {
      throw Exception('Teacher or student cannot be null');
    }
    _teacher = teacher;
    _student = student;
  }

  /// Key for review creation form
  GlobalKey<FormState> get formKey => _formKey;
  /// Teacher name
  String get teacherName => _teacher?.name ?? '';
  /// Student name
  String get studentName => _student?.name ?? '';

  /// Set [value] as new [description]
  void setDescription(String? value) {
    description = value ?? '';
  }

  /// Set [value] as new [title]
  void setTitle(String? value) {
    title = value ?? '';
  }

  /// Validate [value].
  /// If validation passes, then return null
  /// Otherwise return error message
  String? validateTitle(String? value) {
    return value?.isEmpty ?? true ? 'Title cannot be null' : null;
  }

  /// Set [index] as new index for rate row
  /// [index] numbers indicates number of stars
  /// Also use [refresh] to display new state of rate row 
  void setRateNumber(int index, void Function() refresh) {
    rate = index + 1;
    refresh();
  }

  /// Methods triggers [ReviewManager] to save review.
  /// Also [context] is required to show bottom sheet with success or error message
  void saveReview(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      await ReviewManager.create(
          dataManager, _teacher!, studentId, title, description, rate);
      await showSuccessMessageAsync(context, 'Review created');
      Navigator.of(context).pop();
      return;
    }
    showErrorMessage(context, 'Validation error');
  }
}
