import 'package:flutter/material.dart';
import 'package:teachent_app/controller/controller.dart';
import 'package:teachent_app/view/pages/student_creation_page/student_creation_page.dart';
import 'package:teachent_app/view/pages/teacher_creation_page/teacher_creation_page.dart';

/// Controller for Profile Select Page
class ProfileSelectPageController extends BaseController {
  /// Method triggers [TeacherCreationPage] to create account with teacher profile
  void goToAcocuntTeacherCreationPage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const TeacherCreationPage()));
  }

  /// Method triggers [StudentCreationPage] to create account with student profile
  void goToAcocuntStudentCreationPage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const StudentCreationPage()));
  }
}
