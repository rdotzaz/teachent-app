import 'package:flutter/material.dart';

import 'package:teachent_app/controller/controller.dart';
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
      // ignore: avoid_print
      print('App configuration doesn\'t exists');
      isAppConfigAlreadyExists = false;
    }
  }

  Future<void> someLogic() async {
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

    // ignore: avoid_print
    print('Adding data...');
    await dataManager.database.addTopics(allTopics);
    await dataManager.database.addTools(allTools);
    await dataManager.database.addPlaces(allPlaces);
    await dataManager.database.addLevels(educationLevels);

    /// --------------------------------------------------------------------
    await Future.delayed(const Duration(seconds: 1));
  }

  void nextPage(BuildContext context) async {
    await someLogic();

    bool isTeacher = true;
    String userId = '';
    if (isAppConfigAlreadyExists) {
      final appConfiguration = dataManager.database.getAppConfiguration();
      isTeacher = appConfiguration.isTeacher;
      userId = appConfiguration.userId;
    }

    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => isAppConfigAlreadyExists
            ? (isTeacher
                ? TeacherHomePage(userId: userId)
                : StudentHomePage(userId: userId))
            : const LoginPage()));
  }
}
