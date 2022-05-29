import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachent_app/controller/pages/teacher_request_page/teacher_request_page_controller.dart';
import 'package:teachent_app/controller/pages/teacher_request_page/bloc/refresh_bloc.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';
import 'package:teachent_app/model/db_objects/lesson_date.dart';
import 'package:teachent_app/model/db_objects/request.dart';
import 'package:teachent_app/model/db_objects/student.dart';
import 'package:teachent_app/view/widgets/chip_list.dart';
import 'package:teachent_app/view/widgets/label.dart';
import 'package:teachent_app/view/widgets/messages.dart';
import 'package:teachent_app/view/widgets/single_card.dart';

import 'other_day_widget.dart';
import 'buttons.dart';

/// Page for teacher to accept/reject cooperation with student
/// Also on this page teacher manages request. After receiving request from student, teacher can
/// - accept or reject new request date by student
/// - write private message to student
// ignore: must_be_immutable
class TeacherRequestPage extends StatelessWidget {
  TeacherRequestPage(
      {required Request request,
      KeyId? teacherId,
      Student? student,
      LessonDate? lessonDate,
      Key? key})
      : super(key: key) {
    _requestPageController =
        TeacherRequestPageController(request, teacherId, student, lessonDate);
  }

  TeacherRequestPageController? _requestPageController;
  double width = 0;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => RefreshBloc(_requestPageController!))
        ],
        child: Scaffold(
            body: FutureBuilder(
                future: _requestPageController!.init(),
                builder: (_, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    return _mainWidget(context);
                  }
                  return _errorWidget(snapshot.error.toString());
                })));
  }

  Widget _mainWidget(BuildContext context) {
    return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(children: [
          _checkStatus(),
          _infoCard(),
          if (_requestPageController!.tools.isNotEmpty) _tools(),
          if (_requestPageController!.places.isNotEmpty) _places(),
          if (_requestPageController!.wasOtherDateRequested &&
              _requestPageController!.isEnabled)
            OtherDayWidget(controller: _requestPageController!),
          if (_requestPageController!.isEnabled)
            Buttons(controller: _requestPageController!),
          const SizedBox(height: 50),
          Messages(controller: _requestPageController!)
        ]));
  }

  Widget _checkStatus() {
    return Container(
        width: width,
        color: _requestPageController!.getStatusColor(),
        child: Column(children: [
          Padding(
              padding: const EdgeInsets.fromLTRB(0, 80, 0, 8),
              child: Text(_requestPageController!.statusInfo,
                  style: const TextStyle(fontSize: 18, color: Colors.white))),
          Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 8),
              child: Text(_requestPageController!.additionalInfo,
                  style: const TextStyle(fontSize: 18, color: Colors.white))),
        ]));
  }

  Widget _infoCard() {
    return SingleCardWidget(
        title: 'Request',
        titleColor: Colors.black,
        bodyWidget: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Label(
                text: 'Name: ${_requestPageController!.studentName}',
                fontSize: 22),
            Label(text: 'Date: ${_requestPageController!.date}', fontSize: 20),
            Label(
                text: _requestPageController!.isCycled
                    ? 'Lesson is cycled'
                    : 'One-time lesson'),
            Label(text: 'Price: ${_requestPageController!.price}'),
            Chip(
                label: Label(
                    text: 'Topic: ${_requestPageController!.topic.name}',
                    color: Colors.white,
                    padding: 8),
                backgroundColor: Colors.blue)
          ],
        ));
  }

  Widget _tools() {
    return ChipHorizontalList(
        title: 'Tools',
        isNotEmptyCondition: _requestPageController!.tools.isNotEmpty,
        listLength: _requestPageController!.tools.length,
        emptyInfo: '',
        elementBuilder: (_, index) {
          return Chip(
              padding: const EdgeInsets.all(12.0),
              label: Text(_requestPageController!.tools[index].name,
                  style: const TextStyle(fontSize: 18, color: Colors.white)),
              backgroundColor: Colors.blue);
        });
  }

  Widget _places() {
    return ChipHorizontalList(
        title: 'Places',
        isNotEmptyCondition: _requestPageController!.places.isNotEmpty,
        listLength: _requestPageController!.places.length,
        emptyInfo: '',
        elementBuilder: (_, index) {
          return Chip(
              padding: const EdgeInsets.all(12.0),
              label: Text(_requestPageController!.places[index].name,
                  style: const TextStyle(fontSize: 18, color: Colors.white)),
              backgroundColor: Colors.blue);
        });
  }

  Widget _errorWidget(String errorMessage) {
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
