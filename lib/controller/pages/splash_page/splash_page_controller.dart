import 'package:flutter/material.dart';
import 'dart:developer' as dev;

import 'package:teachent_app/controller/controller.dart';
import 'package:teachent_app/view/pages/home_page/home_page.dart';
import 'package:teachent_app/view/pages/login_page/login_page.dart';
import 'package:teachent_app/view/pages/teacher_creation_page.dart/teacher_creation_page.dart';

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
    await Future.delayed(const Duration(seconds: 3));
  }

  void nextPage(BuildContext context) async {
    await someLogic();

    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) =>
            isAppConfigAlreadyExists ? const HomePage() : const LoginPage()));
  }
}
