import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachent_app/controller/pages/student_request_page/bloc/message_refresh_bloc.dart';
import 'package:teachent_app/controller/pages/student_request_page/student_request_page_controller.dart';
import 'package:teachent_app/controller/pages/student_request_page/bloc/request_day_bloc.dart';
import 'package:teachent_app/controller/pages/student_request_page/bloc/request_topic_bloc.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';
import 'package:teachent_app/model/db_objects/lesson_date.dart';
import 'package:teachent_app/model/db_objects/teacher.dart';
import 'package:teachent_app/view/pages/student_request_page/request_day_field.dart';
import 'package:teachent_app/view/widgets/custom_button.dart';
import 'package:teachent_app/view/widgets/label.dart';
import 'package:teachent_app/view/widgets/chip_list.dart';
import 'package:teachent_app/view/widgets/messages.dart';
import 'package:teachent_app/view/widgets/single_card.dart';

import 'confirm_button.dart';

/// Page for student to request cooperation with teacher
/// Also on this page student manages request. After sending request to teacher, student can
/// - request for new start date
/// - write private message to teacher
/// - select lesson topic
// ignore: must_be_immutable
class StudentRequestPage extends StatefulWidget {
  StudentRequestPage(
      {KeyId? requestId,
      KeyId? studentId,
      Teacher? teacher,
      LessonDate? lessonDate,
      Key? key})
      : super(key: key) {
    _requestPageController =
        StudentRequestPageController(requestId, studentId, teacher, lessonDate);
  }

  StudentRequestPageController? _requestPageController;

  @override
  State<StudentRequestPage> createState() => _StudentRequestPageState();
}

class _StudentRequestPageState extends State<StudentRequestPage> {
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
              create: (_) => RequestDayBloc(widget._requestPageController!)),
          BlocProvider(
              create: (_) => widget._requestPageController!.requestTopicBloc),
          BlocProvider(
              create: (_) => widget._requestPageController!.messageBloc)
        ],
        child: Scaffold(
            appBar: AppBar(
              title: const Text('Request'),
              elevation: 0,
              leading: const BackButton(color: Colors.black),
              backgroundColor: Colors.white,
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
        physics: const BouncingScrollPhysics(),
        child: Column(children: [
          _checkStatus(),
          _infoCard(),
          _tools(),
          _places(),
          if (widget._requestPageController!.isEnabled) _requestDay(),
          _topicSelecting(),
          _messeges(),
          if (widget._requestPageController!.isEnabled) _sendRequestButton()
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
                text: 'Name: ${widget._requestPageController!.teacherName}',
                fontSize: 22),
            Label(
                text: 'Date: ${widget._requestPageController!.infoDate}',
                fontSize: 20),
            Label(
                text: widget._requestPageController!.isCycled
                    ? 'Lesson is cycled'
                    : 'One-time lesson'),
            Label(text: 'Price: ${widget._requestPageController!.price}'),
          ],
        ));
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
          if (widget._requestPageController!.canCheckStatus)
            Padding(
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 8),
                child: Text(widget._requestPageController!.additionalInfo,
                    style: const TextStyle(fontSize: 18, color: Colors.white))),
        ]));
  }

  Widget _tools() {
    return ChipHorizontalList(
        title: 'Tools',
        isNotEmptyCondition: widget._requestPageController!.tools.isNotEmpty,
        listLength: widget._requestPageController!.tools.length,
        emptyInfo: 'Teacher did not provide any tools',
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
        emptyInfo: 'Teacher did not provide any places',
        elementBuilder: (_, index) {
          return Chip(
              padding: const EdgeInsets.all(12.0),
              label: Text(widget._requestPageController!.places[index].name,
                  style: const TextStyle(fontSize: 18, color: Colors.white)),
              backgroundColor: Colors.blue);
        });
  }

  Widget _requestDay() {
    return BlocBuilder<RequestDayBloc, Widget>(builder: (_, widget) {
      return Container(
          height: widget is RequestDayField ? 250 : 80,
          padding: const EdgeInsets.all(10),
          child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 700), child: widget));
    });
  }

  Widget _topicSelecting() {
    return BlocBuilder<RequestTopicBloc, int>(builder: (_, selectedIndex) {
      return ChipHorizontalList(
          title: 'Topic',
          isNotEmptyCondition: widget._requestPageController!.topics.isNotEmpty,
          listLength: widget._requestPageController!.topics.length,
          emptyInfo: 'Teacher did not provide any topics',
          elementBuilder: (context, index) {
            final isMarked = selectedIndex == index;
            final topic = widget._requestPageController!.topics[index];
            return ActionChip(
                padding: const EdgeInsets.all(10.0),
                label: Text(topic.name,
                    style: TextStyle(
                        fontSize: 14,
                        color: isMarked ? Colors.white : Colors.black)),
                backgroundColor: isMarked ? Colors.blue : Colors.grey,
                onPressed: () {
                  if (widget._requestPageController!.isEnabled) {
                    context
                        .read<RequestTopicBloc>()
                        .add(ToggleTopicEvent(index));
                  }
                });
          });
    });
  }

  Widget _messeges() {
    return BlocBuilder<MessageRefreshBloc, bool>(builder: ((_, __) {
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

  Widget _sendRequestButton() {
    return BlocBuilder<RequestDayBloc, Widget>(builder: (_, __) {
      return ConfirmButton(controller: widget._requestPageController!);
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
