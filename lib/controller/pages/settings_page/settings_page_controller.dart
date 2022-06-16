import 'package:flutter/material.dart';
import 'package:teachent_app/controller/controller.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';
import 'package:teachent_app/model/db_objects/user.dart';
import 'package:teachent_app/view/pages/login_page/login_page.dart';
import 'package:teachent_app/view/widgets/status_bottom_sheet.dart';

/// Controller for Settings Page
class SettingsPageController extends BaseController {
  final KeyId userId;
  late User? user;

  SettingsPageController(this.userId);

  /// Back to Teacher/Student Home Page
  void backToHome(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Future<void> init() async {
    final possibleUser = await dataManager.database.getUser(userId);
    if (possibleUser == null) {
      return;
    }
    user = possibleUser;
  }

  String get name => '';

  /// Show dialog with app informations
  /// Also it allows see all dependency (names, version, copyrights etc.)
  void aboutDialog(BuildContext context) {
    showAboutDialog(context: context);
  }

  // Method triggers actions required to log out current user
  void logOut(BuildContext context) async {
    if (!dataManager.database.isAppConfigurationAlreadyExists()) {
      return;
    }

    dataManager.database.removeAppConfiguration();
    await showSuccessMessageAsync(context, 'User has been successfuly log out');
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginPage()), (route) => false);
  }
}
