import 'package:flutter/material.dart';
import 'package:teachent_app/common/consts.dart';
import 'package:teachent_app/controller/pages/profile_select_page/profile_select_page_controller.dart';

import '../../widgets/profile_button.dart';

/// Page where user can specify what type of user would like to create
class ProfileSelectPage extends StatelessWidget {
  ProfileSelectPage({Key? key}) : super(key: key);

  final _profileSelectPageController = ProfileSelectPageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [selectLabel(), profileButtons(context)],
    ));
  }

  Padding selectLabel() {
    return const Padding(
        padding: EdgeInsets.all(12.0),
        child: Text(
          ProfilePageConsts.selectProfile,
          style: TextStyle(fontSize: 28),
        ));
  }

  Container profileButtons(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ProfileButton(
                profile: ProfilePageConsts.teacher,
                icon: Icons.person,
                color: Colors.blue,
                onPressed: () {
                  _profileSelectPageController
                      .goToAcocuntTeacherCreationPage(context);
                }),
            ProfileButton(
                profile: ProfilePageConsts.student,
                icon: Icons.person,
                color: Colors.red,
                onPressed: () {
                  _profileSelectPageController
                      .goToAcocuntStudentCreationPage(context);
                })
          ],
        ));
  }
}
