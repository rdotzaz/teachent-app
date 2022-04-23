import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachent_app/common/enums.dart';
import 'package:teachent_app/controller/pages/request_page/request_page_controller.dart';
import 'package:teachent_app/controller/pages/request_page/bloc/request_day_bloc.dart';
import 'package:teachent_app/controller/pages/request_page/bloc/request_topic_bloc.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';
import 'package:teachent_app/model/db_objects/lesson_date.dart';
import 'package:teachent_app/model/db_objects/teacher.dart';
import 'package:teachent_app/view/widgets/custom_button.dart';

class RequestPage extends StatelessWidget {
  RequestPage(
      {KeyId? requestId,
      KeyId? studentId,
      Teacher? teacher,
      LessonDate? lessonDate,
      Key? key})
      : super(key: key) {
    _requestPageController =
        RequestPageController(requestId, studentId, teacher, lessonDate);
  }

  RequestPageController? _requestPageController;
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
                    return _mainWidget(context);
                  }
                  return _errorWidget(snapshot.error.toString());
                })));
  }

  Widget _mainWidget(BuildContext context) {
    return SingleChildScrollView(
        child: Column(children: [
      if (_requestPageController!.canCheckStatus) _checkStatus(),
      Padding(
          padding: const EdgeInsets.all(15),
          child: Text('Name: ${_requestPageController!.teacherName}',
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
      _tools(),
      _places(),
      _requestDay(),
      _topicSelecting(),
      _studentMessage(),
      if (_requestPageController!.hasTeacherMessage) _teacherMessage(),
      if (_requestPageController!.canSendRequest) _sendRequestButton(context)
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
            child: _requestPageController!.tools.isEmpty
                ? const SizedBox(
                    height: 100,
                    child: Center(
                        child: Text('Teacher did not provide any tools')))
                : ListView.builder(
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
            child: _requestPageController!.places.isEmpty
                ? const SizedBox(
                    height: 100,
                    child: Center(
                        child: Text('Teacher did not provide any places')))
                : ListView.builder(
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
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(5),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Padding(padding: EdgeInsets.all(5), child: Text('Topic')),
        Container(
            height: 50,
            padding: const EdgeInsets.all(5),
            child:
                BlocBuilder<RequestTopicBloc, int>(builder: (_, selectedIndex) {
              return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _requestPageController!.topics.length,
                  itemBuilder: (context, index) {
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
            }))
      ]),
    );
  }

  Widget _studentMessage() {
    return Container(
        margin: const EdgeInsets.all(15),
        child: CustomButton(
            text: 'Add message for teacher',
            fontSize: 18,
            onPressed: () {},
            buttonColor: Colors.blue));
  }

  Widget _teacherMessage() {
    return Container();
  }

  Widget _checkStatus() {
    return Container(
      width: width,
      color: _requestPageController!.getStatusColor(),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 80, 0, 8),
            child: Chip(
              label: Text(
                _requestPageController!.request!.status.stringValue,
                style: const TextStyle(fontSize: 18, color: Colors.white) 
              ),
              padding: const EdgeInsets.all(8),
              backgroundColor: _requestPageController!.getStatusColor()
            )
          )
        ]
      )
    );
  } 

  Widget _sendRequestButton(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(15),
        child: CustomButton(
            text: 'Send request for lesson',
            fontSize: 18,
            onPressed: () => _requestPageController!.sendRequest(context),
            buttonColor: Colors.green));
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
