import 'package:flutter/material.dart';
import 'package:teachent_app/common/consts.dart';
import 'package:teachent_app/controller/controller.dart';
import 'package:teachent_app/view/widgets/custom_button.dart';

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
    return isEmpty ? 'Login cannot be empty' : null;
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
                      child: Icon(Icons.error_outline,
                          color: Colors.red, size: 75)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      info,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  CustomButton(
                      text: 'Ok',
                      fontSize: 16,
                      onPressed: () {
                        Navigator.of(context).pop();
                      })
                ],
              ));
        });
  }

  void goToSignUpPage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => ProfileSelectPage()));
  }
}
