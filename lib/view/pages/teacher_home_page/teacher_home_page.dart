import 'package:flutter/material.dart';
import 'package:teachent_app/common/enums.dart';
import 'package:teachent_app/common/enum_functions.dart';
import 'package:teachent_app/controller/pages/teacher_home_page/teacher_home_page_controller.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';
import 'package:teachent_app/view/widgets/custom_button.dart';
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
    _teacherHomePageController =
        TeacherHomePageController(widget.userId, refresh);
  }

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: FutureBuilder(
          future: _teacherHomePageController.init(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.connectionState == ConnectionState.done) {
              return _homeWidget(context);
            }
            return _errorWidget(snapshot.error.toString());
          }),
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.blue,
          onPressed: () {
            print('PRESSED');
          },
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text('Report', style: TextStyle(color: Colors.white))),
    );
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

  Widget _homeWidget(BuildContext context) {
    return CustomScrollView(slivers: [
      _appBar(context),
      SliverList(
          delegate: SliverChildListDelegate([
        _searchBarWidget(),
        _nextLessonsWidget(),
        _lessonDateWidget(context),
        _studentsWidget(),
        _requestsWidget()
        //reportsWidget()
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

  Widget _nextLessonsWidget() {
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
      elementBuilder: (context, index) {
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(_teacherHomePageController.lessons[index].date,
              style: const TextStyle(fontSize: 20, color: Colors.white)),
          const SizedBox(height: 10),
          Text(
              _teacherHomePageController.getStudentName(
                  _teacherHomePageController.lessons[index].studentId),
              style: const TextStyle(fontSize: 14, color: Colors.white)),
        ]);
      },
    );
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
      elementBuilder: (context, index) {
        return Column(children: [
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
        ]);
      },
    );
  }

  Widget _lessonDateWidget(BuildContext context) {
    return SingleCardWidget(
        titleColor: Colors.black,
        backgroundColor: Colors.white,
        startAlignment: false,
        rightButton: CustomButton(
            text: 'Add',
            fontSize: 18,
            onPressed: () =>
                _teacherHomePageController.goToLessonPageCreationPage(context),
            buttonColor: Colors.blue),
        title: 'Your lesson dates',
        bodyWidget: GestureDetector(
            onTap: () {},
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                  'Number of dates: ${_teacherHomePageController.lessonDates.length}',
                  style: const TextStyle(color: Colors.black, fontSize: 18)),
              const SizedBox(height: 20),
              Text('Free dates: ${_teacherHomePageController.freeDates}',
                  style: const TextStyle(color: Colors.black, fontSize: 18)),
              const SizedBox(height: 20),
              CustomButton(
                  text: 'Check lesson dates',
                  buttonColor: Colors.blue,
                  fontSize: 18,
                  onPressed: () {})
            ])));
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
      elementBuilder: (context, index) {
        final request = _teacherHomePageController.requests[index];
        return ListTile(
          title: Text(
            request.currentDate,
            style: const TextStyle(fontSize: 20, color: Colors.white)),
          leading: Icon(Icons.send, size: 30, color: Colors.white),
          onTap: () => _teacherHomePageController.goToRequestPage(context, index),
          subtitle: Text(
            request.status.stringValue,
            style: const TextStyle(fontSize: 14, color: Colors.white)
          )
        );
      },
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
