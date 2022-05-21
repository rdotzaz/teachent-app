import 'package:flutter/material.dart';
import 'package:teachent_app/common/consts.dart';
import 'package:teachent_app/controller/controller.dart';
import 'package:teachent_app/controller/pages/student_creation/bloc/load_levels_bloc.dart';
import 'package:teachent_app/model/objects/education_level.dart';
import 'package:teachent_app/model/db_objects/student.dart';
import 'package:teachent_app/view/pages/account_creation_page/account_creation_page.dart';
import 'package:teachent_app/view/widgets/status_bottom_sheet.dart';

/// Controller for Student Creation Page
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

  @override
  void dispose() {
    loadLevelsBloc.close();
  }

  /// Load education levels from database
  Future<void> initLevels() async {
    var levels = await dataManager.database.getAvailableEducationLevel();
    educationLevels.addAll(levels);
    educationLevels.add(EducationLevel(StudentConsts.levelNotSpecified, false));
  }

  final _headerNames = StudentCreationPageConsts.headers;

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
      return StudentCreationPageConsts.nameEmptyError;
    }
    var length = name?.length ?? 0;
    if (length < StudentCreationPageConsts.nameLengthTreshold) {
      return StudentCreationPageConsts.nameLengthError;
    }
    return null;
  }

  void setName(String? nameToSet) {
    name = nameToSet ?? '';
  }

  /// Go to Account Page. Create student object which can be add to database in Account Creation Page
  void goToLoginCreationPage(BuildContext context) {
    if (educationLevel == '') {
      showErrorMessage(context, StudentCreationPageConsts.noLevelError);
    }

    var student =
        Student.noKey(name, EducationLevel(educationLevel, true), [], [], []);
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => AccountCreationPage(student)));
  }
}
