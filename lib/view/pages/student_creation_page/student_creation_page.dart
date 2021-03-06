import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachent_app/common/consts.dart';
import 'package:teachent_app/controller/pages/student_creation/bloc/education_level_bloc.dart';
import 'package:teachent_app/controller/pages/student_creation/bloc/student_creation_bloc.dart';
import 'package:teachent_app/controller/pages/student_creation/student_creation_page_controller.dart';
import 'package:teachent_app/view/pages/student_creation_page/education_level_sub_page.dart';
import 'package:teachent_app/view/pages/student_creation_page/name_student_sub_page.dart';
import 'package:teachent_app/view/widgets/custom_button.dart';
import 'package:teachent_app/view/widgets/header_clipper.dart';

/// Page to create student type account
/// This page contains PageView widget two sub pages
/// - education level sub page
/// - name sub page
class StudentCreationPage extends StatefulWidget {
  const StudentCreationPage({Key? key}) : super(key: key);

  @override
  State<StudentCreationPage> createState() => _StudentCreationPageState();
}

class _StudentCreationPageState extends State<StudentCreationPage> {
  final _studentCreationPageController = StudentCreationPageController();

  @override
  void initState() {
    super.initState();
    _studentCreationPageController.init();
  }

  @override
  void dispose() {
    _studentCreationPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final windowSize = MediaQuery.of(context).size;
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (_) =>
                  StudentCreationBloc(_studentCreationPageController)),
          BlocProvider(
              create: (_) =>
                  EducationLevelBloc(_studentCreationPageController)),
          BlocProvider(
              create: (_) => _studentCreationPageController.loadLevelsBloc)
        ],
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                studentCreationHeader(windowSize.height),
                studentFormView(windowSize.height, windowSize.width),
                buttons(windowSize.height)
              ],
            ),
          ),
        ));
  }

  Widget studentCreationHeader(double height) {
    return Stack(
      children: [
        ClipPath(
            clipper: CreationHeaderClipper(),
            child: Container(height: height / 7, color: Colors.red)),
        BlocBuilder<StudentCreationBloc, int>(builder: (_, __) {
          return Padding(
              padding: const EdgeInsets.all(40),
              child: Text(_studentCreationPageController.headerName,
                  style: const TextStyle(fontSize: 23, color: Colors.white)));
        }),
      ],
    );
  }

  Widget studentFormView(double height, double width) {
    return SizedBox(
      height: height * 0.7,
      width: width,
      child: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _studentCreationPageController.pageController,
        pageSnapping: false,
        children: [
          nameStudentSubPage(_studentCreationPageController),
          educationLevelSubPage(_studentCreationPageController)
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
    return BlocBuilder<StudentCreationBloc, int>(
        builder: (context, pageNumber) {
      return Visibility(
        visible: pageNumber > StudentCreationPageConsts.namePageNumber,
        maintainSize: true,
        maintainAnimation: true,
        maintainState: true,
        child: CustomButton(
            text: StudentCreationPageConsts.back,
            fontSize: 18,
            buttonColor: Colors.red,
            onPressed: () => context
                .read<StudentCreationBloc>()
                .add(SwitchToPrevPageEvent())),
      );
    });
  }

  Widget nextButton() {
    return BlocBuilder<StudentCreationBloc, int>(
        builder: (context, pageNumber) {
      return CustomButton(
          text: pageNumber == StudentCreationPageConsts.namePageNumber
              ? StudentCreationPageConsts.next
              : StudentCreationPageConsts.done,
          fontSize: 18,
          buttonColor: Colors.red,
          onPressed: () {
            if (pageNumber == StudentCreationPageConsts.namePageNumber) {
              context.read<StudentCreationBloc>().add(SwitchToNextPageEvent());
            } else {
              _studentCreationPageController.goToLoginCreationPage(context);
            }
          });
    });
  }
}
