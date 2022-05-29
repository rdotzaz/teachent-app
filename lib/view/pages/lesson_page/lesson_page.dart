import 'package:flutter/material.dart';
import 'package:teachent_app/controller/pages/lesson_page/lesson_page_controller.dart';
import 'package:teachent_app/model/db_objects/lesson.dart';
import 'package:teachent_app/model/db_objects/student.dart';
import 'package:teachent_app/model/db_objects/teacher.dart';
import 'package:teachent_app/view/widgets/label.dart';
import 'package:teachent_app/view/widgets/single_card.dart';
import 'package:teachent_app/view/widgets/custom_button.dart';

/// Page with informations related to single lesson
/// On this page user can cancel lesson
/// Input:
/// [lesson] - lesson object
/// [teacher] - teacher object
/// [student] - student object
/// [isTeacher] - Specify if this will be done by teacher
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
    return Scaffold(
        appBar: AppBar(
            title: Text('Lesson',
                style: TextStyle(
                    color: lessonPageController.isTeacher
                        ? Colors.blue
                        : Colors.red)),
            leading: BackButton(
                color:
                    lessonPageController.isTeacher ? Colors.blue : Colors.red),
            backgroundColor: Colors.transparent,
            elevation: 0),
        body: Column(children: [
          _userInformation(context),
          _cancelLessonButton(context),
        ]));
  }

  Widget _userInformation(BuildContext context) {
    return SingleCardWidget(
        title: lessonPageController.userType,
        titleColor: Colors.black,
        rightButton: CustomButton(
            text: 'More',
            fontSize: 18,
            onPressed: () => lessonPageController.goToProfilePage(context)),
        bodyWidget: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Label(text: lessonPageController.name),
            Chip(
                label: Label(
                    text: lessonPageController.status,
                    color: Colors.white,
                    padding: 8),
                backgroundColor: lessonPageController.getStatusColor())
          ],
        ));
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
