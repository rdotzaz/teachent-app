import 'package:flutter/material.dart';
import 'package:teachent_app/controller/pages/profile_select_page/profile_select_page_controller.dart';
import 'package:teachent_app/view/pages/student_creation_page/student_creation_page.dart';

import '../../widgets/profile_button.dart';
import '../teacher_creation_page.dart/teacher_creation_page.dart';

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
          'Select account profile',
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
                profile: 'Teacher',
                icon: Icons.person,
                color: Colors.blue,
                onPressed: () {
                  _profileSelectPageController
                      .goToAcocuntTeacherCreationPage(context);
                }),
            ProfileButton(
                profile: 'Student',
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
