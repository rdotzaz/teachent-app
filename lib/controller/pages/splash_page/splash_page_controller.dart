import 'package:flutter/material.dart';
import 'dart:developer' as dev;

import 'package:teachent_app/controller/controller.dart';
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
    await Future.delayed(const Duration(seconds: 2));
  }

  void nextPage(BuildContext context, AsyncSnapshot snapshot) {
    var connectionState = snapshot.connectionState;

    if (connectionState == ConnectionState.waiting) {
      return;
    }

    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) =>
            isAppConfigAlreadyExists ? const HomePage() : const LoginPage()));
  }
}
