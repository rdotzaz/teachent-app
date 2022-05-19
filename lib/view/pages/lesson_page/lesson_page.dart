import 'package:flutter/material.dart';
import 'package:teachent_app/controller/pages/lesson_page/lesson_page_controller.dart';
import 'package:teachent_app/model/db_objects/lesson.dart';
import 'package:teachent_app/model/db_objects/student.dart';
import 'package:teachent_app/model/db_objects/teacher.dart';
import 'package:teachent_app/view/widgets/label.dart';
import 'package:teachent_app/view/widgets/single_card.dart';
import 'package:teachent_app/view/widgets/custom_button.dart';

// ignore: must_be_immutable
class LessonPage extends StatelessWidget {
  late LessonPageController lessonPageController;
  LessonPage(
      {Key? key,
      required Lesson lesson,
      required Teacher teacher,
      required Student student,
      required bool isTeacher})
      : super(key: key) {
    lessonPageController =
        LessonPageController(lesson, teacher, student, isTeacher);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        body: Column(children: [
      _appBar(size.height),
      _userInformation(context),
      _status(),
      _cancelLessonButton(context),
    ]));
  }

  Widget _appBar(double height) {
    return Container(
        height: height / 6,
        decoration: const BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15)),
        ),
        padding: const EdgeInsets.all(15),
        child: Align(
            alignment: Alignment.bottomLeft,
            child: Column(children: [
              const Label(text: 'Lesson', color: Colors.white, fontSize: 14),
              Label(
                  text: lessonPageController.date,
                  color: Colors.white,
                  fontSize: 18),
            ])));
  }

  Widget _userInformation(BuildContext context) {
    return Column(children: [
      SingleCardWidget(
          title: lessonPageController.userType,
          rightButton: CustomButton(
              text: 'More',
              fontSize: 18,
              onPressed: () => lessonPageController.goToProfilePage(context)),
          bodyWidget: Label(text: lessonPageController.name))
    ]);
  }

  Widget _status() {
    return CustomButton(
        text: lessonPageController.status,
        fontSize: 18,
        onPressed: () {},
        isEnabled: false,
        buttonColor: lessonPageController.getStatusColor());
  }

  Widget _cancelLessonButton(BuildContext context) {
    return CustomButton(
        text: 'Cancel this lesson',
        fontSize: 18,
        onPressed: () => lessonPageController.cancelLesson(context),
        isEnabled: lessonPageController.isNotCancelled,
        buttonColor: Colors.red);
  }
}
