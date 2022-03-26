import 'package:flutter/material.dart';
import 'package:teachent_app/controller/controller.dart';
import 'package:teachent_app/view/pages/student_creation_page/student_creation_page.dart';
import 'package:teachent_app/view/pages/teacher_creation_page.dart/teacher_creation_page.dart';

class ProfileSelectPageController extends BaseController {
  void goToAcocuntCreationPage<Page extends Widget>(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      if (Page is TeacherCreationPage) {
        return const TeacherCreationPage();
      } else {
        return const StudentCreationPage();
      }
    }));
  }
}
