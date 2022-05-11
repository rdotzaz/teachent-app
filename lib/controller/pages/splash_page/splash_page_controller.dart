import 'package:flutter/material.dart';

import 'package:teachent_app/controller/controller.dart';
import 'package:teachent_app/controller/notifications/notification_manager.dart';
import 'package:teachent_app/model/objects/education_level.dart';
import 'package:teachent_app/model/objects/topic.dart';
import 'package:teachent_app/model/objects/tool.dart';
import 'package:teachent_app/model/objects/place.dart';
import 'package:teachent_app/view/pages/login_page/login_page.dart';
import 'package:teachent_app/view/pages/student_home_page/student_home_page.dart';
import 'package:teachent_app/view/pages/teacher_home_page/teacher_home_page.dart';

/// Controller for Splash Page
class SplashPageController extends BaseController {
  bool isAppConfigAlreadyExists = true;

  @override
  void init() {
    if (!dataManager.database.isAppConfigurationAlreadyExists()) {
      print('[SplashPageController] App configuration doesn\'t exists');
      isAppConfigAlreadyExists = false;
    }
  }

  Future<void> someLogic() async {
    /// TODO - Lists only for testing purposes.
    /// ------------------------------------------------------------------
    final allTopics = [
      Topic('Math', false),
      Topic('Computer Science', false),
      Topic('English', false),
      Topic('Spanish', false),
      Topic('Geography', false)
    ];

    final allTools = [Tool('Discord', false), Tool('Microsoft Teams', false)];

    final allPlaces = [
      Place('Wroclaw', false),
      Place('Warsaw', false),
      Place('Krakow', false),
      Place('Berlin', false),
      Place('London', false)
    ];

    final educationLevels = [
      EducationLevel('Primiary', false),
      EducationLevel('High School', false),
      EducationLevel('University', false)
    ];

    print('[Testing data] Adding data...');
    await dataManager.database.addTopics(allTopics);
    print('[Testing data] Added topics');
    await dataManager.database.addTools(allTools);
    print('[Testing data] Added tools');
    await dataManager.database.addPlaces(allPlaces);
    print('[Testing data] Added places');
    await dataManager.database.addLevels(educationLevels);
    print('[Testing data] Added levels');

    /// --------------------------------------------------------------------
    await Future.delayed(const Duration(seconds: 2));
  }

  void nextPage(BuildContext context) async {
    await someLogic();
    //await NotificationManager.configure();

    bool isTeacher = true;
    if (isAppConfigAlreadyExists) {
      final appConfiguration = dataManager.database.getAppConfiguration();
      isTeacher = appConfiguration.isTeacher;
    }

    // TODO - Remove dummy value
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => isAppConfigAlreadyExists
            ? (isTeacher
                ? const TeacherHomePage(userId: 'dummy')
                : const StudentHomePage(userId: 'dummy'))
            : const LoginPage()));
  }
}
