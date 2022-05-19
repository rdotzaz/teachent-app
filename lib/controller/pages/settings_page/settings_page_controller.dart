import 'package:flutter/material.dart';
import 'package:teachent_app/controller/controller.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';
import 'package:teachent_app/model/db_objects/user.dart';

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
}
