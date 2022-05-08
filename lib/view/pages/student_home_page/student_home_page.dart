import 'package:flutter/material.dart';
import 'package:teachent_app/common/date.dart';
import 'package:teachent_app/common/enum_functions.dart';
import 'package:teachent_app/controller/pages/student_home_page/student_home_page_controller.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';
import 'package:teachent_app/view/widgets/single_card.dart';

class StudentHomePage extends StatefulWidget {
  final KeyId userId;
  const StudentHomePage({Key? key, required this.userId}) : super(key: key);

  @override
  _StudentHomePageState createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  late StudentHomePageController _studentHomePageController;

  @override
  void initState() {
    super.initState();
    _studentHomePageController =
        StudentHomePageController(widget.userId, refresh);
  }

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: _studentHomePageController.init(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.connectionState == ConnectionState.done) {
                return homeWidget(context);
              }
              return errorWidget(snapshot.error.toString());
            }));
  }

  Widget appBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 150,
      backgroundColor: Colors.white,
      actions: [settings(context)],
      flexibleSpace: FlexibleSpaceBar(
          title: Text('Hi\n${_studentHomePageController.studentName}',
              style: const TextStyle(color: Colors.black)),
          background: Container(color: Colors.white)),
    );
  }

  Widget settings(BuildContext context) {
    return GestureDetector(
      onTap: () => _studentHomePageController.goToSettingsPage(context),
      child: const Padding(
        padding: EdgeInsets.all(18.0),
        child: Icon(
          Icons.settings,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget homeWidget(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => refresh(),
      child: CustomScrollView(slivers: [
        appBar(context),
        SliverList(
            delegate: SliverChildListDelegate([
          searchBarWidget(),
          nextLessonsWidget(),
          teachersWidget(),
          requestsWidget(),
          //reportsWidget()
        ]))
      ])
    );
  }

  Widget searchBarWidget() {
    return GestureDetector(
        onTap: () => _studentHomePageController.goToSearchPage(context),
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
                    Text('Search teachers...',
                        style: TextStyle(fontSize: 18, color: Colors.grey))
                  ],
                ),
              ),
            )));
  }

  Widget nextLessonsWidget() {
    return SingleCardListWidget(
      backgroundColor: Colors.white,
      shadowColor: Colors.grey,
      title: 'Next lessons',
      titleColor: Colors.black,
      boxHeight: 200.0,
      isNotEmptyCondition: _studentHomePageController.areLessons,
      listLength: _studentHomePageController.lessons.length,
      elementBackgroundColor: Colors.red,
      emptyInfo: 'No lessons',
      emptyIcon: Icons.free_breakfast,
      elementBuilder: (context, index) {
        final date = DateFormatter.getString(
            _studentHomePageController.lessons[index].date);
        return GestureDetector(
            onTap: () =>
                _studentHomePageController.goToLessonPage(context, index),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(date,
                  style: const TextStyle(fontSize: 14, color: Colors.white)),
              const SizedBox(height: 20),
              Text(
                  _studentHomePageController.getTeacherName(
                      _studentHomePageController.lessons[index].teacherId),
                  style: const TextStyle(fontSize: 12, color: Colors.white)),
            ]));
      },
    );
  }

  Widget teachersWidget() {
    return SingleCardListWidget(
      backgroundColor: Colors.white,
      shadowColor: Colors.grey,
      title: 'Your teachers',
      titleColor: Colors.black,
      boxHeight: 150.0,
      elementHeight: 150.0,
      elementWidth: 150.0,
      isNotEmptyCondition: _studentHomePageController.areTeachers,
      listLength: _studentHomePageController.teachers.length,
      elementBackgroundColor: Colors.red,
      emptyInfo: 'No teachers',
      emptyIcon: Icons.person,
      scrollDirection: Axis.horizontal,
      elementBuilder: (context, index) {
        return GestureDetector(
            onTap: () =>
                _studentHomePageController.goToTeacherProfile(context, index),
            child: Column(children: [
              const Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 50,
                  )),
              const SizedBox(height: 20),
              Text(_studentHomePageController.teachers[index].name,
                  style: const TextStyle(fontSize: 18, color: Colors.white)),
            ]));
      },
    );
  }

  Widget requestsWidget() {
    return SingleCardListWidget(
      backgroundColor: Colors.white,
      shadowColor: Colors.grey,
      title: 'Requests',
      titleColor: Colors.black,
      boxHeight: 300.0,
      isNotEmptyCondition: _studentHomePageController.areRequests,
      listLength: _studentHomePageController.requests.length,
      elementBackgroundColor: Colors.red,
      emptyInfo: 'No requests',
      emptyIcon: Icons.free_breakfast,
      elementBuilder: (context, index) {
        final request = _studentHomePageController.requests[index];
        final currentDate = DateFormatter.getString(request.currentDate);
        return ListTile(
            title: Text(currentDate,
                style: const TextStyle(fontSize: 20, color: Colors.white)),
            leading: Icon(Icons.send, size: 30, color: Colors.white),
            onTap: () =>
                _studentHomePageController.goToRequestPage(context, index),
            subtitle: Text(request.status.stringValue,
                style: const TextStyle(fontSize: 14, color: Colors.white)));
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
