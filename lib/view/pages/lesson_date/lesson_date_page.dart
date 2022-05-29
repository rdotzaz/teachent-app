import 'package:flutter/material.dart';
import 'package:teachent_app/common/date.dart';
import 'package:teachent_app/common/enum_functions.dart';
import 'package:teachent_app/controller/pages/lesson_date/lesson_date_page_controller.dart';
import 'package:teachent_app/model/db_objects/lesson_date.dart';
import 'package:teachent_app/view/widgets/single_card.dart';
import 'package:teachent_app/view/widgets/label.dart';

/// Page with informations related to lesson date - cooperation between teacher and student
/// Input:
/// [lessonDate] - lesson date (cooperation) object
/// [isTeacher] - Specify if it is view from teacher point of view
// ignore: must_be_immutable
class LessonDatePage extends StatelessWidget {
  late LessonDatePageController lessonDateController;
  LessonDatePage(LessonDate lessonDate, bool isTeacher, {Key? key})
      : super(key: key) {
    lessonDateController = LessonDatePageController(lessonDate, isTeacher);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(''),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: BackButton(
              color: lessonDateController.isTeacher ? Colors.blue : Colors.red),
        ),
        body: FutureBuilder(
            future: lessonDateController.init(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.connectionState == ConnectionState.done) {
                return _homeWidget(context);
              }
              return Container(color: Colors.red);
            }));
  }

  Widget _homeWidget(BuildContext context) {
    return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(children: [
          SingleCardWidget(
              title: 'Cooperation',
              backgroundColor:
                  lessonDateController.isTeacher ? Colors.blue : Colors.red,
              shadowColor:
                  lessonDateController.isTeacher ? Colors.blue : Colors.red,
              bodyWidget: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (lessonDateController.isNotFree &&
                        lessonDateController.isTeacher)
                      Label(
                          text: 'Student: ${lessonDateController.studentName}',
                          color: Colors.white,
                          fontSize: 22),
                    if (!lessonDateController.isTeacher)
                      Label(
                          text: 'Teacher: ${lessonDateController.teacherName}',
                          color: Colors.white,
                          fontSize: 22),
                    Container(
                      margin: const EdgeInsets.all(15),
                      child: Chip(
                          padding: const EdgeInsets.all(8),
                          label: Text(lessonDateController.cycleType,
                              style: TextStyle(
                                  color: lessonDateController.isTeacher
                                      ? Colors.blue
                                      : Colors.red)),
                          backgroundColor: Colors.white),
                    ),
                    Label(
                        text: 'Price: ${lessonDateController.price}',
                        color: Colors.white),
                    Label(
                        text: 'Start date: ${lessonDateController.startDate}',
                        color: Colors.white),
                    if (lessonDateController.hasTools) _tools(),
                    if (lessonDateController.hasPlaces) _places()
                  ])),
          SingleCardListWidget(
            backgroundColor: Colors.white,
            shadowColor: Colors.grey,
            title: 'Reports',
            titleColor: Colors.black,
            boxHeight: 200,
            isNotEmptyCondition: lessonDateController.areLessons,
            listLength: lessonDateController.lessonEntities.length,
            elementBackgroundColor: Colors.grey[200]!,
            emptyInfo: 'No reports available',
            emptyIcon: Icons.free_breakfast,
            elementBuilder: (context, index) {
              final lesson = lessonDateController.lessonEntities[index].lesson;
              final report = lessonDateController.lessonEntities[index].report;
              return Column(children: [
                Label(text: DateFormatter.getString(lesson.date)),
                Chip(
                    padding: const EdgeInsets.all(8),
                    label: Text(lesson.status.stringValue,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        )),
                    backgroundColor: lessonDateController.isTeacher
                        ? Colors.blue
                        : Colors.red),
                if (report != null) Label(text: report.title),
                if (report != null)
                  Label(text: report.description, fontSize: 14),
              ]);
            },
          )
        ]));
  }

  Widget _tools() {
    return Container(
        margin: const EdgeInsets.only(left: 15),
        height: 70,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: lessonDateController.tools.length,
            itemBuilder: (_, index) {
              return Chip(
                  padding: const EdgeInsets.all(10),
                  label: Text(lessonDateController.tools[index].name,
                      style: TextStyle(
                          color: lessonDateController.isTeacher
                              ? Colors.blue
                              : Colors.red)),
                  backgroundColor: Colors.white);
            }));
  }

  Widget _places() {
    return Container(
        margin: const EdgeInsets.only(left: 15),
        height: 70,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: lessonDateController.places.length,
            itemBuilder: (_, index) {
              return Chip(
                  padding: const EdgeInsets.all(10),
                  label: Text(lessonDateController.places[index].name,
                      style: TextStyle(
                          color: lessonDateController.isTeacher
                              ? Colors.blue
                              : Colors.red)),
                  backgroundColor: Colors.white);
            }));
  }
}
