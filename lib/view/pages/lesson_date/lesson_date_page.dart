import 'package:flutter/material.dart';
import 'package:teachent_app/controller/pages/lesson_date/lesson_date_page_controller.dart';
import 'package:teachent_app/model/db_objects/lesson_date.dart';
import 'package:teachent_app/view/widgets/single_card.dart';
import 'package:teachent_app/view/widgets/custom_button.dart';
import 'package:teachent_app/view/widgets/label.dart';

class LessonDatePage extends StatelessWidget {
  late LessonDatePageController lessonDateController;
  LessonDatePage(LessonDate lessonDate, bool isTeacher, {Key? key})
      : super(key: key) {
    lessonDateController = LessonDatePageController(lessonDate, isTeacher);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('')),
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
        child: Column(children: [
      SingleCardWidget(
          title: 'Cooperation',
          backgroundColor:
              lessonDateController.isTeacher ? Colors.blue : Colors.red,
          shadowColor:
              lessonDateController.isTeacher ? Colors.blue : Colors.red,
          bodyWidget: Column(children: [
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
            Chip(
                padding: const EdgeInsets.all(15),
                label: Text(lessonDateController.cycleType,
                    style: TextStyle(
                        color: lessonDateController.isTeacher
                            ? Colors.blue
                            : Colors.red)),
                backgroundColor: Colors.white),
            Label(
                text: 'Price: ${lessonDateController.price}',
                color: Colors.white),
            Label(
                text: 'Start date: ${lessonDateController.startDate}',
                color: Colors.white),
            //_tools(),
            //_places()
          ])),
      const SizedBox(height: 50),
      SingleCardListWidget(
        backgroundColor: Colors.white,
        shadowColor: Colors.grey,
        title: 'Reports',
        titleColor: Colors.black,
        boxHeight: 100,
        isNotEmptyCondition: lessonDateController.areReports,
        listLength: lessonDateController.reports.length,
        elementBackgroundColor: Colors.grey,
        emptyInfo: 'No reports available',
        emptyIcon: Icons.free_breakfast,
        elementBuilder: (context, index) {
          return Column(children: [
            Label(text: lessonDateController.reports[index].title),
            Label(
                text: lessonDateController.reports[index].description,
                fontSize: 14)
          ]);
        },
      )
    ]));
  }

  Widget _tools() {
    return Padding(
        padding: const EdgeInsets.all(8),
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
    return Padding(
        padding: const EdgeInsets.all(8),
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
