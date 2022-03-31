import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachent_app/common/consts.dart';
import 'package:teachent_app/controller/pages/teacher_creation/bloc/other_topic_bloc.dart';
import 'package:teachent_app/controller/pages/teacher_creation/bloc/teacher_creation_bloc.dart';
import 'package:teachent_app/controller/pages/teacher_creation/bloc/work_mode_bloc.dart';
import 'package:teachent_app/controller/pages/teacher_creation/teacher_creation_page_controller.dart';
import 'package:teachent_app/view/pages/teacher_creation_page.dart/place_sub_page.dart';
import 'package:teachent_app/view/pages/teacher_creation_page.dart/topic_sub_page.dart';
import 'package:teachent_app/view/widgets/custom_button.dart';

import 'name_sub_page.dart';
import '../../widgets/header_clipper.dart';

class TeacherCreationPage extends StatefulWidget {
  const TeacherCreationPage({Key? key}) : super(key: key);

  @override
  State<TeacherCreationPage> createState() => _TeacherCreationPageState();
}

class _TeacherCreationPageState extends State<TeacherCreationPage> {
  final _teacherCreationPageController = TeacherCreationPageController();

  @override
  void initState() {
    super.initState();
    _teacherCreationPageController.init();
  }

  @override
  void dispose() {
    _teacherCreationPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final windowSize = MediaQuery.of(context).size;
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (_) =>
                  TeacherCreationBloc(_teacherCreationPageController)),
          BlocProvider(create: (_) => _teacherCreationPageController.topicBloc),
          BlocProvider(
              create: (_) => OtherTopicBloc(_teacherCreationPageController)),
          BlocProvider(create: (_) => WorkModeBloc()),
          BlocProvider(create: (_) => _teacherCreationPageController.toolBloc),
          BlocProvider(create: (_) => _teacherCreationPageController.placeBloc)
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
            clipper: CreationHeaderClipper(),
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
        physics: const NeverScrollableScrollPhysics(),
        controller: _teacherCreationPageController.pageController,
        pageSnapping: false,
        children: [
          nameSubPage(_teacherCreationPageController),
          topicSubPage(_teacherCreationPageController),
          placeSubPage(_teacherCreationPageController)
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
        visible: pageNumber > TeacherCreationPageConsts.namePageNumber,
        maintainSize: true,
        maintainAnimation: true,
        maintainState: true,
        child: CustomButton(
            text: TeacherCreationPageConsts.back,
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
      return CustomButton(
          text: pageNumber == TeacherCreationPageConsts.placePageNumber ? 
            TeacherCreationPageConsts.done :
            TeacherCreationPageConsts.next,
          fontSize: 18,
          buttonColor: Colors.blue,
          onPressed: () {
            if (pageNumber == 2) {
              _teacherCreationPageController.goToLoginCreationPage(context);
            } else {
              context.read<TeacherCreationBloc>().add(SwitchToNextPageEvent());
            }
          });
    });
  }
}
