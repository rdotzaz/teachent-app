import 'package:flutter/material.dart';
import 'package:teachent_app/common/consts.dart';
import 'package:teachent_app/common/enums.dart';
import 'package:teachent_app/controller/controller.dart';
import 'package:teachent_app/model/db_objects/app_configuration.dart';
import 'package:teachent_app/model/db_objects/user.dart';
import 'package:teachent_app/view/widgets/status_bottom_sheet.dart';
import 'package:teachent_app/view/pages/student_home_page/student_home_page.dart';
import 'package:teachent_app/view/pages/teacher_home_page/teacher_home_page.dart';

import '../../../view/pages/profile_select_page/profile_select_page.dart';

/// Controller for Login Page
class LoginFormController extends BaseController {
  final _loginFormKey = GlobalKey<FormState>();
  String login = '';
  String password = '';

  /// Key object for form widget to validate fields under form widget
  GlobalKey<FormState> get key => _loginFormKey;

  /// Validates [login] passed by user in text field
  /// If [login] validated properly, then method returns null
  /// Otherwise returns error message
  String? validateLogin(String? login) {
    var isEmpty = login?.isEmpty ?? true;
    return isEmpty ? LoginPageConsts.loginError : null;
  }

  /// Validates [password] passed by user in text field
  /// If [password] validated properly, then method returns null
  /// Otherwise returns error message
  String? validatePassword(String? password) {
    var isEmpty = password?.isEmpty ?? true;
    return isEmpty ? LoginPageConsts.passwordError : null;
  }

  /// Set [loginToSet] as new login
  void setLogin(String? loginToSet) {
    login = loginToSet ?? '';
  }

  /// Set [passwordToSet] as new password
  void setPassword(String? passwordToSet) {
    password = passwordToSet ?? '';
  }

  /// Method triggers login form validation
  Future<void> buttonValidator(BuildContext context) async {
    final validationResult = _loginFormKey.currentState?.validate() ?? false;

    if (validationResult) {
      _loginFormKey.currentState?.save();

      showLoadingDialog(context, 'Loading...');

      Future.delayed(const Duration(seconds: 1), () async {
        final result =
            await dataManager.database.checkLoginAndPassword(login, password);
        Navigator.of(context).pop();

        if (result.status == LoginStatus.logicError) {
          showErrorMessage(context, LoginPageConsts.logicError);
        } else if (result.status == LoginStatus.loginNotFound) {
          showErrorMessage(context, LoginPageConsts.loginNotFound);
        } else if (result.status == LoginStatus.invalidPassword) {
          showErrorMessage(context, LoginPageConsts.invalidPassword);
        } else {
          final user = result.user!;
          _addAppConfiguration(user);
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
            return user.isTeacher
                ? TeacherHomePage(userId: user.key)
                : StudentHomePage(userId: user.key);
          }));
        }
      });
      return;
    }

    showErrorMessage(context, LoginPageConsts.validationFailed);
  }

  /// Method triggers new page -> ProfileSelectPage to start sign up process.
  void goToSignUpPage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => ProfileSelectPage()));
  }

  void _addAppConfiguration(User user) {
    if (dataManager.database.isAppConfigurationAlreadyExists()) {
      return;
    }
    dataManager.database.addAppConfiguration(
        AppConfiguration(user.login, false, user.isTeacher));
  }
}
