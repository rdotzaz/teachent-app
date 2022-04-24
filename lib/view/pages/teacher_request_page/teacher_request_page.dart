import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachent_app/common/enums.dart';
import 'package:teachent_app/controller/pages/teacher_request_page/teacher_request_page_controller.dart';
import 'package:teachent_app/controller/pages/teacher_request_page/bloc/refresh_bloc.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';
import 'package:teachent_app/model/db_objects/lesson_date.dart';
import 'package:teachent_app/model/db_objects/request.dart';
import 'package:teachent_app/model/db_objects/student.dart';
import 'package:teachent_app/view/widgets/custom_button.dart';

import 'other_day_widget.dart';
import 'buttons.dart';

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
        child: Column(children: [
      _checkStatus(),
      Padding(
          padding: const EdgeInsets.all(15),
          child: Text('Name: ${_requestPageController!.studentName}',
              style: const TextStyle(color: Colors.black, fontSize: 18))),
      Padding(
          padding: const EdgeInsets.all(15),
          child: Text('Date: ${_requestPageController!.date}',
              style: const TextStyle(color: Colors.black, fontSize: 18))),
      Padding(
          padding: const EdgeInsets.all(15),
          child: Text(
              _requestPageController!.isCycled
                  ? 'Lesson is cycled'
                  : 'One-time lesson',
              style: const TextStyle(color: Colors.black, fontSize: 18))),
      Padding(
          padding: const EdgeInsets.all(15),
          child: Text('Price: ${_requestPageController!.price}',
              style: const TextStyle(color: Colors.black, fontSize: 18))),
      Padding(
          padding: const EdgeInsets.all(15),
          child: Text('Topic: ${_requestPageController!.topic}',
              style: const TextStyle(color: Colors.black, fontSize: 18))),
      if(_requestPageController!.tools.isNotEmpty) _tools(),
      if(_requestPageController!.places.isNotEmpty) _places(),
      if(_requestPageController!.wasOtherDateRequested) OtherDayWidget(controller: _requestPageController!),
      _teacherMessage(),
      if (_requestPageController!.hasStudentMessage) _studentMessage(),
      Buttons(controller: _requestPageController!)
    ]));
  }

  Widget _tools() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(2, 2))
        ],
      ),
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Padding(padding: EdgeInsets.all(5), child: Text('Tools')),
        Container(
            height: 70,
            padding: const EdgeInsets.all(5),
            child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _requestPageController!.tools.length,
                    itemBuilder: (_, index) {
                      return Chip(
                          padding: const EdgeInsets.all(12.0),
                          label: Text(_requestPageController!.tools[index].name,
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.white)),
                          backgroundColor: Colors.blue);
                    }))
      ]),
    );
  }

  Widget _places() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(2, 2))
        ],
      ),
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Padding(padding: EdgeInsets.all(5), child: Text('Places')),
        Container(
            height: 70,
            padding: const EdgeInsets.all(5),
            child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _requestPageController!.places.length,
                    itemBuilder: (_, index) {
                      return Chip(
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          label: Text(
                              _requestPageController!.places[index].name,
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.white)),
                          backgroundColor: Colors.blue);
                    }))
      ]),
    );
  }

  Widget _studentMessage() {
    return Container();
  }

  Widget _teacherMessage() {
    return Container(
        margin: const EdgeInsets.all(15),
        child: CustomButton(
            text: 'Add message for student',
            fontSize: 18,
            onPressed: () {},
            buttonColor: Colors.blue));
  }

  Widget _checkStatus() {
    return Container(
        width: width,
        color: _requestPageController!.getStatusColor(),
        child: Column(children: [
          Padding(
              padding: const EdgeInsets.fromLTRB(0, 80, 0, 8),
              child: Text(
                  _requestPageController!.request.status.stringValue,
                  style: const TextStyle(fontSize: 18, color: Colors.white))),
          if (_requestPageController!.hasAdditionalInfo())
            Padding(
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 8),
                child: Text(_requestPageController!.getStatusAdditionalInfo(),
                    style: const TextStyle(fontSize: 18, color: Colors.white))),
        ]));
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
