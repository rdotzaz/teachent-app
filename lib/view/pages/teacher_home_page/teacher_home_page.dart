import 'package:flutter/material.dart';
import 'package:teachent_app/common/date.dart';
import 'package:teachent_app/common/enum_functions.dart';
import 'package:teachent_app/controller/pages/teacher_home_page/teacher_home_page_controller.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';
import 'package:teachent_app/view/widgets/custom_button.dart';
import 'package:teachent_app/view/widgets/label.dart';
import 'package:teachent_app/view/widgets/single_card.dart';

/// Home page from teacher perspective
/// Input:
/// [userId] - user id (teacher id)
class TeacherHomePage extends StatefulWidget {
  final KeyId userId;
  const TeacherHomePage({Key? key, required this.userId}) : super(key: key);

  @override
  State<TeacherHomePage> createState() => _TeacherHomePageState();
}

class _TeacherHomePageState extends State<TeacherHomePage>
    with SingleTickerProviderStateMixin {
  late TeacherHomePageController _teacherHomePageController;

  @override
  void initState() {
    super.initState();
    _teacherHomePageController =
        TeacherHomePageController(widget.userId, refresh);
  }

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _teacherHomePageController.init(),
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: Colors.grey[200],
            body: _body(context, snapshot),
            floatingActionButton: FloatingActionButton.extended(
                backgroundColor: Colors.blue,
                onPressed: () =>
                    _teacherHomePageController.goToReportPage(context),
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text('Report',
                    style: TextStyle(color: Colors.white))),
          );
        });
  }

  Widget _body(BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return _homeLoadingWidget(context);
    } else if (snapshot.connectionState == ConnectionState.done) {
      return _homeWidget(context);
    }
    return _errorWidget(snapshot.error.toString());
  }

  Widget _appBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 150,
      backgroundColor: Colors.transparent,
      actions: [_settings(context)],
      flexibleSpace: FlexibleSpaceBar(
          title: Text('Hi\n${_teacherHomePageController.teacherName}',
              style: const TextStyle(color: Colors.black)),
          background: Container(color: Colors.transparent)),
    );
  }

  Widget _settings(BuildContext context) {
    return GestureDetector(
      onTap: () => _teacherHomePageController.goToSettingsPage(context),
      child: const Padding(
        padding: EdgeInsets.all(18.0),
        child: Icon(
          Icons.settings,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _homeLoadingWidget(BuildContext context) {
    return CustomScrollView(slivers: [
      _appBar(context),
      SliverList(
          delegate: SliverChildListDelegate([
        _searchBarWidget(),
        const CardLoadingWidget(
            title: 'Next lessons', height: 200, backgroundColor: Colors.white),
        const CardLoadingWidget(
            title: 'Your cooperations',
            height: 200,
            backgroundColor: Colors.white),
        const CardLoadingWidget(
            title: 'Your students', height: 150, backgroundColor: Colors.white),
        const CardLoadingWidget(
            title: 'Requests', height: 300, backgroundColor: Colors.white),
      ]))
    ]);
  }

  Widget _homeWidget(BuildContext context) {
    return CustomScrollView(slivers: [
      _appBar(context),
      SliverList(
          delegate: SliverChildListDelegate([
        _searchBarWidget(),
        _nextLessonsWidget(context),
        _lessonDateWidget(context),
        _studentsWidget(),
        _requestsWidget()
      ]))
    ]);
  }

  Widget _searchBarWidget() {
    return GestureDetector(
        onTap: () => _teacherHomePageController.goToSearchPage(context),
        child: Hero(
            tag: 'search',
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: const Offset(2, 2))
                ],
              ),
              margin: const EdgeInsets.all(15),
              padding: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: const [
                    Icon(Icons.search, color: Colors.grey, size: 25),
                    SizedBox(width: 20),
                    Text('Search people...',
                        style: TextStyle(fontSize: 18, color: Colors.grey))
                  ],
                ),
              ),
            )));
  }

  Widget _nextLessonsWidget(BuildContext context) {
    return SingleCardListWidget(
        backgroundColor: Colors.white,
        shadowColor: Colors.grey,
        title: 'Next lessons',
        titleColor: Colors.black,
        boxHeight: 200.0,
        isNotEmptyCondition: _teacherHomePageController.areLessons,
        listLength: _teacherHomePageController.lessons.length,
        elementBackgroundColor: Colors.blue,
        emptyInfo: 'No lessons',
        emptyIcon: Icons.free_breakfast,
        moreButton: CustomButton(
          text: 'More',
          fontSize: 14,
          onPressed: () => _teacherHomePageController.showMoreLessons(
              context, _nextLessonItemWidget),
        ),
        elementBuilder: (context, index) =>
            _nextLessonItemWidget(context, index));
  }

  Widget _nextLessonItemWidget(BuildContext context, int index) {
    final date =
        DateFormatter.getString(_teacherHomePageController.lessons[index].date);
    return GestureDetector(
        onTap: () => _teacherHomePageController.goToLessonPage(context, index),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(date, style: const TextStyle(fontSize: 20, color: Colors.white)),
          const SizedBox(height: 10),
          Text(
              _teacherHomePageController.getStudentName(
                  _teacherHomePageController.lessons[index].studentId),
              style: const TextStyle(fontSize: 14, color: Colors.white)),
        ]));
  }

  Widget _studentsWidget() {
    return SingleCardListWidget(
        backgroundColor: Colors.white,
        shadowColor: Colors.grey,
        title: 'Your students',
        titleColor: Colors.black,
        boxHeight: 150.0,
        elementHeight: 150.0,
        elementWidth: 150.0,
        isNotEmptyCondition: _teacherHomePageController.areStudents,
        listLength: _teacherHomePageController.students.length,
        elementBackgroundColor: Colors.blue,
        emptyInfo: 'No students',
        emptyIcon: Icons.person,
        scrollDirection: Axis.horizontal,
        moreButton: CustomButton(
          text: 'More',
          fontSize: 14,
          onPressed: () => _teacherHomePageController.showMoreStudents(
              context, _studentItemWidget),
        ),
        elementBuilder: (context, index) => _studentItemWidget(context, index));
  }

  Widget _studentItemWidget(BuildContext context, int index) {
    return GestureDetector(
        onTap: () =>
            _teacherHomePageController.goToStudentProfile(context, index),
        child: Column(children: [
          const Padding(
              padding: EdgeInsets.all(10),
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 60,
              )),
          const SizedBox(height: 20),
          Text(_teacherHomePageController.students[index].name,
              style: const TextStyle(fontSize: 18, color: Colors.white)),
        ]));
  }

  Widget _lessonDateWidget(BuildContext context) {
    return SingleCardListWidget(
        backgroundColor: Colors.white,
        shadowColor: Colors.grey,
        title: 'Your cooperations',
        titleColor: Colors.black,
        boxHeight: 200.0,
        isNotEmptyCondition: _teacherHomePageController.areDates,
        listLength: _teacherHomePageController.lessonDates.length,
        elementBackgroundColor: Colors.blue,
        emptyInfo: 'No cooperations',
        emptyIcon: Icons.free_breakfast,
        moreButton: CustomButton(
          text: 'More',
          fontSize: 14,
          onPressed: () => _teacherHomePageController.showMoreLessonDates(
              context, _lessonDateItemWidget),
        ),
        rightButton: CustomButton(
            text: 'Add',
            fontSize: 18,
            onPressed: () =>
                _teacherHomePageController.goToLessonPageCreationPage(context),
            buttonColor: Colors.blue),
        elementBuilder: (context, index) =>
            _lessonDateItemWidget(context, index));
  }

  Widget _lessonDateItemWidget(BuildContext context, int index) {
    final lessonDate = _teacherHomePageController.lessonDates[index];
    return GestureDetector(
        onTap: () =>
            _teacherHomePageController.goToLessonDatePage(context, index),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (!lessonDate.isFree)
            Label(
                text: _teacherHomePageController
                    .getStudentName(lessonDate.studentId),
                fontSize: 12,
                color: Colors.white,
                padding: 8),
          Label(
              text: 'Start date: ${DateFormatter.getString(lessonDate.date)}',
              fontSize: 12,
              color: Colors.white,
              padding: 8),
          Padding(
              padding: const EdgeInsets.all(8),
              child: Chip(
                  label: Text(
                      _teacherHomePageController
                          .lessonDates[index].cycleType.stringValue,
                      style: const TextStyle(fontSize: 12, color: Colors.blue)),
                  backgroundColor: Colors.white)),
          if (lessonDate.isFree)
            const Padding(
                padding: EdgeInsets.all(8),
                child: Chip(
                    label: Text('Waiting for cooperator',
                        style: TextStyle(fontSize: 12, color: Colors.blue)),
                    backgroundColor: Colors.white))
        ]));
  }

  Widget _requestsWidget() {
    return SingleCardListWidget(
        backgroundColor: Colors.white,
        shadowColor: Colors.grey,
        title: 'Requests',
        titleColor: Colors.black,
        boxHeight: 300.0,
        isNotEmptyCondition: _teacherHomePageController.areRequests,
        listLength: _teacherHomePageController.requests.length,
        elementBackgroundColor: Colors.blue,
        emptyInfo: 'No requests',
        emptyIcon: Icons.free_breakfast,
        moreButton: CustomButton(
          text: 'More',
          fontSize: 14,
          onPressed: () => _teacherHomePageController.showMoreRequests(
              context, _requestItemWidget),
        ),
        elementBuilder: (context, index) => _requestItemWidget(context, index));
  }

  Widget _requestItemWidget(BuildContext context, int index) {
    final request = _teacherHomePageController.requests[index];
    final currentDate = DateFormatter.getString(request.currentDate);
    return ListTile(
        title: Text(currentDate,
            style: const TextStyle(fontSize: 20, color: Colors.white)),
        leading: const Icon(Icons.send, size: 30, color: Colors.white),
        onTap: () => _teacherHomePageController.goToRequestPage(context, index),
        subtitle: Text(request.status.stringValue,
            style: const TextStyle(fontSize: 14, color: Colors.white)));
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
