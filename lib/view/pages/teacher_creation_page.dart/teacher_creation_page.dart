import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachent_app/controller/pages/teacher_creation/teacher_creation_bloc.dart';
import 'package:teachent_app/controller/pages/teacher_creation/teacher_creation_page_controller.dart';
import 'package:teachent_app/view/pages/teacher_creation_page.dart/topic_sub_page.dart';
import 'package:teachent_app/view/widgets/custom_button.dart';

import 'name_sub_page.dart';
import 'header_clipper.dart';
import 'topic_bloc.dart';

class TeacherCreationPage extends StatelessWidget {
  TeacherCreationPage({Key? key}) : super(key: key);

  final _teacherCreationPageController = TeacherCreationPageController();

  @override
  Widget build(BuildContext context) {
    final windowSize = MediaQuery.of(context).size;
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (_) =>
                  TeacherCreationBloc(_teacherCreationPageController)),
          BlocProvider(
              create: (_) => TopicBloc(_teacherCreationPageController)),
        ],
        child: Scaffold(
          body: Column(
            children: [
              teacherCreationHeader(windowSize.height),
              teacherFormView(),
              buttons(windowSize.height)
            ],
          ),
        ));
  }

  Widget teacherCreationHeader(double height) {
    return Stack(
      children: [
        ClipPath(
            clipper: TeacherCreationHeaderClipper(),
            child: Container(height: height / 8, color: Colors.blue)),
        BlocBuilder<TeacherCreationBloc, int>(builder: (_, __) {
          return Padding(
              padding: const EdgeInsets.all(25),
              child: Text(_teacherCreationPageController.headerName,
                  style: const TextStyle(fontSize: 23, color: Colors.white)));
        }),
      ],
    );
  }

  Widget teacherFormView() {
    return Expanded(
      child: PageView(
        controller: _teacherCreationPageController.pageController,
        pageSnapping: false,
        children: [
          nameSubPage(_teacherCreationPageController),
          topicSubPage(_teacherCreationPageController),
          Container(
            child: const Center(child: Text('Third page')),
          ),
        ],
      ),
    );
  }

  Widget buttons(double height) {
    return Container(
        padding: const EdgeInsets.all(15),
        height: height / 8,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [backButton(), nextButton()]));
  }

  Widget backButton() {
    return BlocBuilder<TeacherCreationBloc, int>(
        builder: (context, pageNumber) {
      return Visibility(
        visible: pageNumber > 0,
        maintainSize: true,
        maintainAnimation: true,
        maintainState: true,
        child: CustomButton(
            text: 'Back',
            fontSize: 18,
            buttonColor: Colors.blue,
            onPressed: () => context
                .read<TeacherCreationBloc>()
                .add(SwitchToPrevPageEvent())),
      );
    });
  }

  Widget nextButton() {
    return BlocBuilder<TeacherCreationBloc, int>(
        builder: (context, pageNumber) {
      return Visibility(
        visible: pageNumber < 2,
        maintainSize: true,
        maintainAnimation: true,
        maintainState: true,
        child: CustomButton(
            text: 'Next',
            fontSize: 18,
            buttonColor: Colors.blue,
            onPressed: () => context
                .read<TeacherCreationBloc>()
                .add(SwitchToNextPageEvent())),
      );
    });
  }
}