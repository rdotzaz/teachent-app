import 'package:flutter/material.dart';
import 'package:teachent_app/common/date.dart';
import 'package:teachent_app/common/enum_functions.dart';
import 'package:teachent_app/controller/animations/loading_animation.dart';
import 'package:teachent_app/controller/pages/student_home_page/student_home_page_controller.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';
import 'package:teachent_app/view/widgets/single_card.dart';

class StudentHomePage extends StatefulWidget {
  final KeyId userId;
  const StudentHomePage({Key? key, required this.userId}) : super(key: key);

  @override
  _StudentHomePageState createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> with SingleTickerProviderStateMixin {
  late StudentHomePageController _studentHomePageController;
  final _loadingAnimationController = LoadingAnimationController();

  @override
  void initState() {
    super.initState();
    _studentHomePageController =
        StudentHomePageController(widget.userId, refresh, _loadingAnimationController);
    _loadingAnimationController.startAnimation(this, refresh);
  }

  void refresh() {
    setState(() {});
  }

  @override
  void dispose() {
    _loadingAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: _studentHomePageController.init(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _homeLoadingWidget(context);
              } else if (snapshot.connectionState == ConnectionState.done) {
                return _homeWidget(context);
              }
              return _errorWidget(snapshot.error.toString());
            }));
  }

  Widget _appBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 150,
      backgroundColor: Colors.white,
      actions: [_settings(context)],
      flexibleSpace: FlexibleSpaceBar(
          title: Text('Hi\n${_studentHomePageController.studentName}',
              style: const TextStyle(color: Colors.black)),
          background: Container(color: Colors.white)),
    );
  }

  Widget _settings(BuildContext context) {
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

  Widget _homeLoadingWidget(BuildContext context) {
    return CustomScrollView(slivers: [
      _appBar(context),
      SliverList(
          delegate: SliverChildListDelegate([
        _searchBarWidget(),
        CardLoadingWidget(
          title: 'Next lessons',
          height: 200,
          backgroundColor: _loadingAnimationController.value!
        ),
        CardLoadingWidget(
          title: 'Your cooperations',
          height: 200,
          backgroundColor: _loadingAnimationController.value!
        ),
        CardLoadingWidget(
          title: 'Your students',
          height: 150,
          backgroundColor: _loadingAnimationController.value!
        ),
        CardLoadingWidget(
          title: 'Requests',
          height: 300,
          backgroundColor: _loadingAnimationController.value!
        ),
      ]))
    ]);
  }

  Widget _homeWidget(BuildContext context) {
    return CustomScrollView(slivers: [
      _appBar(context),
      SliverList(
          delegate: SliverChildListDelegate([
        _searchBarWidget(),
        _nextLessonsWidget(),
        _lessonDatesWidget(),
        _teachersWidget(),
        _requestsWidget()
      ]))
    ]);
  }

  Widget _searchBarWidget() {
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

  Widget _nextLessonsWidget() {
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

  Widget _lessonDatesWidget() {
    return SingleCardListWidget(
      backgroundColor: Colors.white,
      shadowColor: Colors.grey,
      title: 'Your cooperations',
      titleColor: Colors.black,
      boxHeight: 200.0,
      isNotEmptyCondition: _studentHomePageController.areDates,
      listLength: _studentHomePageController.lessonDates.length,
      elementBackgroundColor: Colors.red,
      emptyInfo: 'No cooperations',
      emptyIcon: Icons.free_breakfast,
      elementBuilder: (context, index) {
        return GestureDetector(
            onTap: () =>
                _studentHomePageController.goToLessonDatePage(context, index),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                  _studentHomePageController.getTeacherName(
                      _studentHomePageController.lessons[index].teacherId),
                  style: const TextStyle(fontSize: 12, color: Colors.white)),
              Padding(
                  padding: const EdgeInsets.all(8),
                  child: Chip(
                      label: Text(
                          _studentHomePageController
                              .lessonDates[index].cycleType.stringValue,
                          style:
                              const TextStyle(fontSize: 12, color: Colors.red)),
                      backgroundColor: Colors.white))
            ]));
      },
    );
  }

  Widget _teachersWidget() {
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

  Widget _requestsWidget() {
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
            leading: const Icon(Icons.send, size: 30, color: Colors.white),
            onTap: () =>
                _studentHomePageController.goToRequestPage(context, index),
            subtitle: Text(request.status.stringValue,
                style: const TextStyle(fontSize: 14, color: Colors.white)));
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
