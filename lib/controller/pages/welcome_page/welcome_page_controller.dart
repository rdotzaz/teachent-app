import 'package:flutter/material.dart';
import 'package:teachent_app/controller/controller.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';
import 'package:teachent_app/model/db_objects/student.dart';
import 'package:teachent_app/model/db_objects/teacher.dart';
import 'package:teachent_app/view/pages/student_home_page/student_home_page.dart';
import 'package:teachent_app/view/pages/teacher_home_page/teacher_home_page.dart';

/// Controller for Welcome Page
class WelcomePageController extends BaseController {
  final DatabaseObject dbObject;
  final BuildContext context;
  WelcomePageController(this.context, this.dbObject);

  @override
  void init() async {
    Future.delayed(const Duration(seconds: 2), moveToHomePage);
  }

  /// Method moves user to home page
  /// If user has teacher profile then trigger TeacherHomePage.
  /// Otherwise StudentHomePage
  void moveToHomePage() {
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) {
      if (dbObject is Teacher) {
        return TeacherHomePage(userId: (dbObject as Teacher).userId);
      } else {
        return StudentHomePage(userId: (dbObject as Student).userId);
      }
    }), (_) => false);
  }
}
