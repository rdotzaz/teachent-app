import 'package:flutter/material.dart';
import 'package:teachent_app/common/consts.dart';
import 'package:teachent_app/common/enums.dart';
import 'package:teachent_app/controller/controller.dart';
import 'package:teachent_app/view/widgets/status_bottom_sheet.dart';
import 'package:teachent_app/view/pages/student_home_page/student_home_page.dart';
import 'package:teachent_app/view/pages/teacher_home_page/teacher_home_page.dart';

import '../../../view/pages/profile_select_page/profile_select_page.dart';

class LoginFormController extends BaseController {
  final _loginFormKey = GlobalKey<FormState>();
  String login = '';
  String password = '';

  GlobalKey<FormState> get key => _loginFormKey;

  String? validateLogin(String? login) {
    var isEmpty = login?.isEmpty ?? true;
    return isEmpty ? LoginPageConsts.loginError : null;
  }

  String? validatePassword(String? password) {
    var isEmpty = password?.isEmpty ?? true;
    return isEmpty ? LoginPageConsts.passwordError : null;
  }

  void setLogin(String? loginToSet) {
    login = loginToSet ?? '';
  }

  void setPassword(String? passwordToSet) {
    password = passwordToSet ?? '';
  }

  Future<void> buttonValidator(BuildContext context) async {
    final validationResult = _loginFormKey.currentState?.validate() ?? false;

    if (validationResult) {
      _loginFormKey.currentState?.save();

      final result =
          await dataManager.database.checkLoginAndPassword(login, password);

      if (result.status == LoginStatus.logicError) {
        showErrorMessage(context, LoginPageConsts.logicError);
      }
      else if (result.status == LoginStatus.loginNotFound) {
        showErrorMessage(context, LoginPageConsts.loginNotFound);
      }
      else if (result.status == LoginStatus.invalidPassword) {
        showErrorMessage(context, LoginPageConsts.invalidPassword);
      } else {
        final user = result.user!;
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
          return user.isTeacher
              ? TeacherHomePage(userId: user.key)
              : StudentHomePage(userId: user.key);
        }));
      }
      return;
    }

    showErrorMessage(context, LoginPageConsts.validationFailed);
  }

  void goToSignUpPage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => ProfileSelectPage()));
  }
}
