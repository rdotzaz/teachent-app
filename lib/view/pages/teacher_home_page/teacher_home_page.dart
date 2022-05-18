import 'package:flutter/material.dart';
import 'package:teachent_app/common/date.dart';
import 'package:teachent_app/common/enum_functions.dart';
import 'package:teachent_app/controller/animations/loading_animation.dart';
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

class _TeacherHomePageState extends State<TeacherHomePage> with TickerProviderStateMixin {
  late TeacherHomePageController _teacherHomePageController;
  final _loadingAnimationController = LoadingAnimationController();

  @override
  void initState() {
    super.initState();
    _teacherHomePageController =
        TeacherHomePageController(widget.userId, refresh, _loadingAnimationController);
    _loadingAnimationController.startAnimation(this, refresh);
  }

  @override
  void dispose() {
    _loadingAnimationController.dispose();
    super.dispose();
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
      return const CircularProgressIndicator();
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

  Widget _homeWidget(BuildContext context) {
    return CustomScrollView(slivers: [
      _appBar(context),
      SliverList(
          delegate: SliverChildListDelegate([
        _searchBarWidget(),
        CardLoadingWidget(
          title: 'Next lessons',
          height: 200,
          backgroundColor: _loadingAnimationController.animationValue
        ),
        CardLoadingWidget(
          title: 'Your cooperations',
          height: 200,
          backgroundColor: _loadingAnimationController.animationValue
        ),
        CardLoadingWidget(
          title: 'Your students',
          height: 150,
          backgroundColor: _loadingAnimationController.animationValue
        ),
        CardLoadingWidget(
          title: 'Requests',
          height: 300,
          backgroundColor: _loadingAnimationController.animationValue
        ),
      ]))
    ]);
  }

  Widget _homeLoadingWidget(BuildContext context) {
    return CustomScrollView(slivers: [
      _appBar(context),
      SliverList(
          delegate: SliverChildListDelegate([
        _searchBarWidget(),
        _nextLessonsWidget(),
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
        final date = DateFormatter.getString(
            _teacherHomePageController.lessons[index].date);
        return GestureDetector(
            onTap: () =>
                _teacherHomePageController.goToLessonPage(context, index),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(date,
                  style: const TextStyle(fontSize: 20, color: Colors.white)),
              const SizedBox(height: 10),
              Text(
                  _teacherHomePageController.getStudentName(
                      _teacherHomePageController.lessons[index].studentId),
                  style: const TextStyle(fontSize: 14, color: Colors.white)),
            ]));
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
      },
    );
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
      rightButton: CustomButton(
          text: 'Add',
          fontSize: 18,
          onPressed: () =>
              _teacherHomePageController.goToLessonPageCreationPage(context),
          buttonColor: Colors.blue),
      elementBuilder: (context, index) {
        final isFree = _teacherHomePageController.lessonDates[index].isFree;
        return GestureDetector(
            onTap: () =>
                _teacherHomePageController.goToLessonDatePage(context, index),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              if (!isFree)
                Text(
                    _teacherHomePageController.getStudentName(
                        _teacherHomePageController
                            .lessonDates[index].studentId),
                    style: const TextStyle(fontSize: 12, color: Colors.white)),
              Padding(
                  padding: const EdgeInsets.all(8),
                  child: Chip(
                      label: Text(
                          _teacherHomePageController
                              .lessonDates[index].cycleType.stringValue,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.blue)),
                      backgroundColor: Colors.white)),
              if (isFree)
                Padding(
                    padding: const EdgeInsets.all(8),
                    child: Chip(
                        label: Text('Waiting for cooperator',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.blue)),
                        backgroundColor: Colors.white))
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
      isNotEmptyCondition: _teacherHomePageController.areRequests,
      listLength: _teacherHomePageController.requests.length,
      elementBackgroundColor: Colors.blue,
      emptyInfo: 'No requests',
      emptyIcon: Icons.free_breakfast,
      elementBuilder: (context, index) {
        final request = _teacherHomePageController.requests[index];
        final currentDate = DateFormatter.getString(request.currentDate);
        return ListTile(
            title: Text(currentDate,
                style: const TextStyle(fontSize: 20, color: Colors.white)),
            leading: Icon(Icons.send, size: 30, color: Colors.white),
            onTap: () =>
                _teacherHomePageController.goToRequestPage(context, index),
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
