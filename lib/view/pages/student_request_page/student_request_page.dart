import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachent_app/controller/pages/student_request_page/student_request_page_controller.dart';
import 'package:teachent_app/controller/pages/student_request_page/bloc/request_day_bloc.dart';
import 'package:teachent_app/controller/pages/student_request_page/bloc/request_topic_bloc.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';
import 'package:teachent_app/model/db_objects/lesson_date.dart';
import 'package:teachent_app/model/db_objects/teacher.dart';
import 'package:teachent_app/view/widgets/label.dart';
import 'package:teachent_app/view/widgets/chip_list.dart';
import 'package:teachent_app/view/widgets/messages.dart';

import 'confirm_button.dart';

class StudentRequestPage extends StatelessWidget {
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
  double width = 0;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => RequestDayBloc(_requestPageController!)),
          BlocProvider(create: (_) => _requestPageController!.requestTopicBloc)
        ],
        child: Scaffold(
            body: FutureBuilder(
                future: _requestPageController!.init(),
                builder: (_, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    return _mainWidget();
                  }
                  return _errorWidget(snapshot.error.toString());
                })));
  }

  Widget _mainWidget() {
    return SingleChildScrollView(
        child: Column(children: [
      _checkStatus(),
      Label(text: 'Name: ${_requestPageController!.teacherName}'),
      Label(text: 'Date: ${_requestPageController!.date}'),
      Label(
          text: _requestPageController!.isCycled
              ? 'Lesson is cycled'
              : 'One-time lesson'),
      Label(text: 'Price: ${_requestPageController!.price}'),
      _tools(),
      _places(),
      _requestDay(),
      _topicSelecting(),
      Messages(controller: _requestPageController!),
      _sendRequestButton()
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
          if (_requestPageController!.canCheckStatus)
            Padding(
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 8),
                child: Text(_requestPageController!.additionalInfo,
                    style: const TextStyle(fontSize: 18, color: Colors.white))),
        ]));
  }

  Widget _tools() {
    return ChipHorizontalList(
        title: 'Tools',
        isNotEmptyCondition: _requestPageController!.tools.isNotEmpty,
        listLength: _requestPageController!.tools.length,
        emptyInfo: 'Teacher did not provide any tools',
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
        emptyInfo: 'Teacher did not provide any places',
        elementBuilder: (_, index) {
          return Chip(
              padding: const EdgeInsets.all(12.0),
              label: Text(_requestPageController!.places[index].name,
                  style: const TextStyle(fontSize: 18, color: Colors.white)),
              backgroundColor: Colors.blue);
        });
  }

  Widget _requestDay() {
    return BlocBuilder<RequestDayBloc, Widget>(builder: (_, widget) {
      return Container(
          height: 80,
          padding: const EdgeInsets.all(10),
          child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 700), child: widget));
    });
  }

  Widget _topicSelecting() {
    return BlocBuilder<RequestTopicBloc, int>(builder: (_, selectedIndex) {
      return ChipHorizontalList(
          title: 'Topic',
          isNotEmptyCondition: _requestPageController!.topics.isNotEmpty,
          listLength: _requestPageController!.topics.length,
          emptyInfo: 'Teacher did not provide any topics',
          elementBuilder: (context, index) {
            final isMarked = selectedIndex == index;
            final topic = _requestPageController!.topics[index];
            return ActionChip(
                padding: const EdgeInsets.all(10.0),
                label: Text(topic.name,
                    style: TextStyle(
                        fontSize: 14,
                        color: isMarked ? Colors.white : Colors.black)),
                backgroundColor: isMarked ? Colors.blue : Colors.grey,
                onPressed: () => context
                    .read<RequestTopicBloc>()
                    .add(ToggleTopicEvent(index)));
          });
    });
  }

  Widget _sendRequestButton() {
    return BlocBuilder<RequestDayBloc, Widget>(builder: (_, __) {
      return ConfirmButton(controller: _requestPageController!);
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
