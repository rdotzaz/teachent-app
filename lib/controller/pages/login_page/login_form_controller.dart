import 'package:flutter/material.dart';
import 'package:teachent_app/common/consts.dart';
import 'package:teachent_app/controller/controller.dart';
import 'package:teachent_app/view/widgets/custom_button.dart';
import 'package:teachent_app/view/widgets/status_bottom_sheet.dart';

import '../../../view/pages/profile_select_page/profile_select_page.dart';

class LoginFormController extends BaseController {
  final _loginFormKey = GlobalKey<FormState>();
  String login = '';
  String password = '';

  GlobalKey<FormState> get key => _loginFormKey;

  String? validateLogin(String? login) {
    var isEmpty = login?.isEmpty ?? true;
    return isEmpty ? 'Login cannot be empty' : null;
  }

  String? validatePassword(String? password) {
    var isEmpty = password?.isEmpty ?? true;
    return isEmpty ? 'Password cannot be empty' : null;
  }

  void setLogin(String? loginToSet) {
    login = loginToSet ?? '';
  }

  void setPassword(String? passwordToSet) {
    password = passwordToSet ?? '';
  }

  Future<void> buttonValidator(BuildContext context) async {
    var validationResult = _loginFormKey.currentState?.validate() ?? false;

    if (validationResult) {
      _loginFormKey.currentState?.save();

      var userId =
          await dataManager.database.checkLoginAndPassword(login, password);

      if (userId == DatabaseConsts.emptyKey) {
        showErrorMessage(context, 'Login has not been found');
      } else {
        // TODO
        // Go to Home page
      }
      return;
    }

    showErrorMessage(context, 'Validation failed');
  }

  void showErrorMessage(BuildContext context, String info) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
        builder: (_) =>
            StatusBottomSheet(info: info, status: BottomSheetStatus.error));
  }

  void goToSignUpPage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => ProfileSelectPage()));
  }
}
