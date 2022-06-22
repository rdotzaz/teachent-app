import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachent_app/controller/pages/student_request_page/bloc/message_refresh_bloc.dart';
import 'package:teachent_app/controller/pages/teacher_request_page/teacher_request_page_controller.dart';
import 'package:teachent_app/controller/pages/teacher_request_page/bloc/refresh_bloc.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';
import 'package:teachent_app/model/db_objects/lesson_date.dart';
import 'package:teachent_app/model/db_objects/request.dart';
import 'package:teachent_app/model/db_objects/student.dart';
import 'package:teachent_app/view/widgets/chip_list.dart';
import 'package:teachent_app/view/widgets/custom_button.dart';
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
class TeacherRequestPage extends StatefulWidget {
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

  @override
  State<TeacherRequestPage> createState() => _TeacherRequestPageState();
}

class _TeacherRequestPageState extends State<TeacherRequestPage> {
  double width = 0;
  late dynamic futureFunction;

  @override
  void initState() {
    super.initState();
    futureFunction = widget._requestPageController!.init();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (_) => RefreshBloc(widget._requestPageController!)),
          BlocProvider(
              create: (_) => widget._requestPageController!.messageBloc)
        ],
        child: Scaffold(
            appBar: AppBar(
              title: const Text('Request'),
              elevation: 0,
              leading: const BackButton(color: Colors.white),
              backgroundColor: widget._requestPageController!.getStatusColor(),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  FutureBuilder(
                      future: futureFunction,
                      builder: (_, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.connectionState ==
                            ConnectionState.done) {
                          return _mainWidget(context);
                        }
                        return _errorWidget(snapshot.error.toString());
                      }),
                  _messageSendField(context)
                ],
              ),
            )));
  }

  Widget _mainWidget(BuildContext context) {
    return SingleChildScrollView(
        child: Column(children: [
      _checkStatus(),
      _infoCard(),
      if (widget._requestPageController!.tools.isNotEmpty) _tools(),
      if (widget._requestPageController!.places.isNotEmpty) _places(),
      if (widget._requestPageController!.wasOtherDateRequested &&
          widget._requestPageController!.isEnabled)
        OtherDayWidget(controller: widget._requestPageController!),
      if (widget._requestPageController!.isEnabled)
        Buttons(controller: widget._requestPageController!),
      const SizedBox(height: 50),
      _messages()
    ]));
  }

  Widget _checkStatus() {
    return Container(
        width: width,
        color: widget._requestPageController!.getStatusColor(),
        child: Column(children: [
          Padding(
              padding: const EdgeInsets.fromLTRB(0, 80, 0, 8),
              child: Text(widget._requestPageController!.statusInfo,
                  style: const TextStyle(fontSize: 18, color: Colors.white))),
          Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 8),
              child: Text(widget._requestPageController!.additionalInfo,
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
                text: 'Name: ${widget._requestPageController!.studentName}',
                fontSize: 22),
            Label(
                text: 'Date: ${widget._requestPageController!.date}',
                fontSize: 20),
            Label(
                text: widget._requestPageController!.isCycled
                    ? 'Lesson is cycled'
                    : 'One-time lesson'),
            Label(text: 'Price: ${widget._requestPageController!.price}'),
            Chip(
                label: Label(
                    text: 'Topic: ${widget._requestPageController!.topic.name}',
                    color: Colors.white,
                    padding: 8),
                backgroundColor: Colors.blue)
          ],
        ));
  }

  Widget _tools() {
    return ChipHorizontalList(
        title: 'Tools',
        isNotEmptyCondition: widget._requestPageController!.tools.isNotEmpty,
        listLength: widget._requestPageController!.tools.length,
        emptyInfo: '',
        elementBuilder: (_, index) {
          return Chip(
              padding: const EdgeInsets.all(12.0),
              label: Text(widget._requestPageController!.tools[index].name,
                  style: const TextStyle(fontSize: 18, color: Colors.white)),
              backgroundColor: Colors.blue);
        });
  }

  Widget _places() {
    return ChipHorizontalList(
        title: 'Places',
        isNotEmptyCondition: widget._requestPageController!.places.isNotEmpty,
        listLength: widget._requestPageController!.places.length,
        emptyInfo: '',
        elementBuilder: (_, index) {
          return Chip(
              padding: const EdgeInsets.all(12.0),
              label: Text(widget._requestPageController!.places[index].name,
                  style: const TextStyle(fontSize: 18, color: Colors.white)),
              backgroundColor: Colors.blue);
        });
  }

  Widget _messages() {
    return BlocBuilder<MessageRefreshBloc, bool>(builder: ((context, state) {
      return Messages(controller: widget._requestPageController!);
    }));
  }

  Widget _messageSendField(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(15),
      child: Row(children: [
        Expanded(
          child: TextField(
              controller: widget._requestPageController?.textController),
        ),
        CustomButton(
            text: 'Send',
            fontSize: 14,
            onPressed: () {
              if (widget._requestPageController != null) {
                widget._requestPageController!.sendMessageAndRefresh(context);
              }
            })
      ]),
    );
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
