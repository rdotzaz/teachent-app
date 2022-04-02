import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:teachent_app/controller/pages/teacher_home_page/teacher_home_page_controller.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';
import 'package:teachent_app/view/widgets/single_card.dart';

class TeacherHomePage extends StatefulWidget {
  final KeyId userId;
  const TeacherHomePage({Key? key, required this.userId}) : super(key: key);

  @override
  State<TeacherHomePage> createState() => _TeacherHomePageState();
}

class _TeacherHomePageState extends State<TeacherHomePage> {
  late TeacherHomePageController _teacherHomePageController;

  @override
  void initState() {
    super.initState();
    _teacherHomePageController = TeacherHomePageController(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: _teacherHomePageController.init(),
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.connectionState == ConnectionState.done) {
                return homeWidget();
              }
              return errorWidget(snapshot.error.toString());
            }));
  }

  Widget appBar() {
    return SliverAppBar(
      expandedHeight: 200,
      backgroundColor: Colors.white,
      actions: [settings()],
      flexibleSpace: FlexibleSpaceBar(
          title: Text('Hi\n${_teacherHomePageController.teacherName}',
              style: const TextStyle(color: Colors.black)),
          background: Container(color: Colors.white)),
    );
  }

  Widget settings() {
    return const Padding(
      padding: EdgeInsets.all(18.0),
      child: Icon(
        Icons.settings,
        color: Colors.black,
      ),
    );
  }

  Widget homeWidget() {
    return CustomScrollView(slivers: [
      appBar(),
      SliverList(
          delegate: SliverChildListDelegate([
        nextLessonsWidget(),
        studentsWidget(),
        requestsWidget(),
        //reportsWidget()
      ]))
    ]);
  }

  Widget nextLessonsWidget() {
    return SingleCardListWidget(
      backgroundColor: Colors.blue,
      title: 'Next lessons',
      boxHeight: 200.0,
      isNotEmptyCondition: _teacherHomePageController.areLessons,
      listLength: _teacherHomePageController.lessons.length,
      elementBackgroundColor: Colors.white,
      emptyInfo: 'No lessons',
      emptyIcon: Icons.free_breakfast,
      elementBuilder: (context, index) {
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(_teacherHomePageController.lessons[index].date,
              style: const TextStyle(fontSize: 14, color: Colors.black)),
          const SizedBox(height: 20),
          Text(
              _teacherHomePageController.getStudentName(
                  _teacherHomePageController.lessons[index].studentId),
              style: const TextStyle(fontSize: 12, color: Colors.black)),
        ]);
      },
    );
  }

  Widget studentsWidget() {
    return SingleCardListWidget(
      backgroundColor: Colors.red,
      title: 'Your students',
      boxHeight: 150.0,
      elementHeight: 150.0,
      elementWidth: 150.0,
      isNotEmptyCondition: _teacherHomePageController.areStudents,
      listLength: _teacherHomePageController.students.length,
      elementBackgroundColor: Colors.red[900]!,
      emptyInfo: 'No students',
      emptyIcon: Icons.person,
      scrollDirection: Axis.horizontal,
      elementBuilder: (context, index) {
        return Column(children: [
          const Padding(
              padding: EdgeInsets.all(10),
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 50,
              )),
          const SizedBox(height: 20),
          Text(_teacherHomePageController.students[index].name,
              style: const TextStyle(fontSize: 18, color: Colors.white)),
        ]);
      },
    );
  }

  Widget requestsWidget() {
    return SingleCardListWidget(
      backgroundColor: Colors.blue,
      title: 'Requests',
      boxHeight: 300.0,
      isNotEmptyCondition: _teacherHomePageController.areRequests,
      listLength: _teacherHomePageController.requests.length,
      elementBackgroundColor: Colors.white,
      emptyInfo: 'No requests',
      emptyIcon: Icons.free_breakfast,
      elementBuilder: (context, index) {
        return Container();
      },
    );
  }

  Widget errorWidget(String errorMessage) {
    return Container(
      color: Colors.red,
      child: Column(children: [
        const Padding(
            padding: EdgeInsets.all(30),
            child: Icon(Icons.error, color: Colors.white)),
        Text(errorMessage),
      ]),
    );
  }
}
