import 'package:flutter/material.dart';
import 'package:teachent_app/controller/controller.dart';
import 'package:teachent_app/controller/pages/student_creation/bloc/load_levels_bloc.dart';
import 'package:teachent_app/model/objects/education_level.dart';
import 'package:teachent_app/model/db_objects/student.dart';
import 'package:teachent_app/view/pages/account_creation_page/account_creation_page.dart';

class StudentCreationPageController extends BaseController {
  String name = '';
  String educationLevel = '';

  int _pageNumber = 0;
  final _pageViewController = PageController();

  late LoadLevelsBloc loadLevelsBloc;

  final _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> get formKey => _formKey;
  PageController get pageController => _pageViewController;

  final List<EducationLevel> educationLevels = [];

  @override
  void init() {
    loadLevelsBloc = LoadLevelsBloc(this);
    loadLevelsBloc.add(LoadAllLevelsEvent());
  }

  Future<void> initLevels() async {
    var levels = await dataManager.database.getAvailableEducationLevel();
    educationLevels.addAll(levels);
  }

  final _headerNames = ['What\'s your name?', 'Choose your education level'];

  String get headerName => _headerNames[_pageNumber];

  void moveToPage(int pageNumber) {
    _pageNumber = pageNumber;
    _pageViewController.animateToPage(pageNumber,
        duration: const Duration(milliseconds: 700), curve: Curves.ease);
  }

  bool validateFields() {
    return _formKey.currentState?.validate() ?? false;
  }

  String? validateName(String? name) {
    var isEmpty = name?.isEmpty ?? true;
    if (isEmpty) {
      return 'Name cannot be empty';
    }
    var length = name?.length ?? 0;
    if (length < 5) {
      return 'Name length must be greater than 4';
    }
    return null;
  }

  void setName(String? nameToSet) {
    name = nameToSet ?? '';
  }

  void goToLoginCreationPage(BuildContext context) {
    var student = Student.noKey(name, EducationLevel(educationLevel, true), [], []);
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => AccountCreationPage(student)));
  }
}
