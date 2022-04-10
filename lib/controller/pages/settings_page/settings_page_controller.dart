import 'package:flutter/material.dart';
import 'package:teachent_app/controller/controller.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';
import 'package:teachent_app/model/db_objects/user.dart';

class SettingsPageController extends BaseController {
    final KeyId userId;
    late User? user;

    SettingsPageController(this.userId);
    void backToHome(BuildContext context) {
        Navigator.of(context).pop();
    }

    @override
    Future<void> init() async {
        final possibleUser = await dataManager.database.getUser(userId);
        if (possibleUser == null) {
            print('No User found');
            return;
        }
        user = possibleUser;
    }
}