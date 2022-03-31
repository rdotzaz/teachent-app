import 'package:flutter/material.dart';
import 'dart:developer' as dev;

import 'package:teachent_app/controller/controller.dart';
import 'package:teachent_app/model/objects/education_level.dart';
import 'package:teachent_app/model/objects/topic.dart';
import 'package:teachent_app/model/objects/tool.dart';
import 'package:teachent_app/model/objects/place.dart';
import 'package:teachent_app/view/pages/home_page/home_page.dart';
import 'package:teachent_app/view/pages/login_page/login_page.dart';

class SplashPageController extends BaseController {
  bool isAppConfigAlreadyExists = true;

  @override
  void init() {
    if (!dataManager.database.isAppConfigurationAlreadyExists()) {
      dev.log('[SplashPageController] App configuration doesn\'t exists');
      isAppConfigAlreadyExists = false;
    }
  }

  Future<void> someLogic() async {
    /// [TODO] Arrays only for testing purposes.
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

    await dataManager.database.addTopics(allTopics);
    await dataManager.database.addTools(allTools);
    await dataManager.database.addPlaces(allPlaces);
    await dataManager.database.addLevels(educationLevels);

    /// --------------------------------------------------------------------
    await Future.delayed(const Duration(seconds: 3));
  }

  void nextPage(BuildContext context) async {
    await someLogic();

    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) =>
            isAppConfigAlreadyExists ? const HomePage() : const LoginPage()));
  }
}
