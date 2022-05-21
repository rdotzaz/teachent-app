import 'package:flutter/material.dart';
import 'package:teachent_app/controller/controller.dart';
import 'package:teachent_app/controller/managers/review_manager.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';
import 'package:teachent_app/model/db_objects/student.dart';
import 'package:teachent_app/model/db_objects/teacher.dart';
import 'package:teachent_app/view/widgets/status_bottom_sheet.dart';

class ReviewCreationPageController extends BaseController {
  final KeyId teacherId;
  final KeyId studentId;
  final void Function() refresh;

  ReviewCreationPageController(this.refresh, this.teacherId, this.studentId);

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

  GlobalKey<FormState> get formKey => _formKey;
  String get teacherName => _teacher?.name ?? '';
  String get studentName => _student?.name ?? '';

  void setDescription(String? value) {
    description = value ?? '';
  }

  void setTitle(String? value) {
    title = value ?? '';
  }

  String? validateTitle(String? value) {
    return value?.isEmpty ?? true ? 'Title cannot be null' : null;
  }

  void setRateNumber(int index) {
    rate = index + 1;
    refresh();
  }

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
