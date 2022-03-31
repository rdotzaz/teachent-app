import 'package:flutter/material.dart';
import 'package:teachent_app/controller/controller.dart';
import 'package:teachent_app/view/pages/student_creation_page/student_creation_page.dart';
import 'package:teachent_app/view/pages/teacher_creation_page.dart/teacher_creation_page.dart';

class ProfileSelectPageController extends BaseController {
  void goToAcocuntTeacherCreationPage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const TeacherCreationPage()));
  }

  void goToAcocuntStudentCreationPage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const StudentCreationPage()));
  }
}
