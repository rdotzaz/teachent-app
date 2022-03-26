import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:teachent_app/common/consts.dart';
import 'package:teachent_app/controller/controller.dart';
import 'package:teachent_app/view/pages/login_page/custom_button.dart';

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
      return;
    }

    showErrorMessage(context);
  }

  void showErrorMessage(BuildContext context) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        builder: (context) {
          final windowSize = MediaQuery.of(context).size;
          return SizedBox(
              height: windowSize.height / 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Fail',
                      style: TextStyle(fontSize: 32),
                    ),
                  ),
                  CustomButton(
                      text: 'Ok',
                      fontSize: 18,
                      onPressed: () {
                        Navigator.of(context).pop();
                      })
                ],
              ));
        });
  }
}
