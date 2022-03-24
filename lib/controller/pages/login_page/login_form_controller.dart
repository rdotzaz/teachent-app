import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:teachent_app/common/consts.dart';
import 'package:teachent_app/controller/controller.dart';

class LoginFormController extends BaseController {
  final _loginFormKey = GlobalKey<FormState>();
  String login = '';
  String password = '';

  GlobalKey<FormState> get key => _loginFormKey;

  String? validateLogin(String? login) {
    return login;
  }

  String? validatePassword(String? password) {
    return password;
  }

  void setLogin(String? login) {
    login = login ?? '';
  }

  void setPassword(String? password) {
    password = password ?? '';
  }

  Future<void> buttonValidator(BuildContext context) async {
    var validationResult = _loginFormKey.currentState?.validate() ?? false;

    if (validationResult) {
      _loginFormKey.currentState?.save();

      var userId =
          await dataManager.database.checkLoginAndPassword(login, password);

      if (userId == DatabaseConsts.emptyKey) {
        dev.log('[LoginFormController] Login validation failed');
      } else {
        dev.log('[LoginFormController] Login validation passed');
      }
    }
  }
}
