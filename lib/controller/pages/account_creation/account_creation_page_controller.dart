import 'package:flutter/material.dart';
import 'package:teachent_app/common/algorithms.dart';
import 'package:teachent_app/controller/controller.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';
import 'package:teachent_app/model/db_objects/student.dart';
import 'package:teachent_app/model/db_objects/teacher.dart';
import 'package:teachent_app/model/db_objects/user.dart';
import 'package:teachent_app/view/pages/welcome_page/welcome_page.dart';
import 'package:teachent_app/view/widgets/status_bottom_sheet.dart';

/// Controller for Account Creation Page
class AccountCreationPageController extends BaseController {
  final DatabaseObject dbObject;
  AccountCreationPageController(this.dbObject);

  Student? student;
  Teacher? teacher;

  String login = '';
  String password = '';
  String repeatedPassword = '';

  final _creationKey = GlobalKey<FormState>();

  /// Key object for form widget to validate fields under form widget
  GlobalKey<FormState> get creationKey => _creationKey;

  @override
  void init() {
    if (dbObject is Student) {
      student = dbObject as Student;
    } else if (dbObject is Teacher) {
      teacher = dbObject as Teacher;
    } else {
      throw Exception('Unknown type of dbObject ${dbObject.runtimeType}');
    }
  }

  @override
  void dispose() {}

  /// Name of account profile
  String get profileName => teacher != null ? 'Teacher' : 'Student';

  /// User name
  String get name {
    return teacher?.name ?? student?.name ?? '';
  }

  /// Validate [login] passed by application user in text field
  /// Returns null if [login] properly validated. Otherwise error message
  String? validateLogin(String? login) {
    var isEmpty = login?.isEmpty ?? true;
    return isEmpty ? 'Login cannot be empty' : null;
  }

  /// Validate [password] passed by application user in text field
  /// Returns null if [password] properly validated. Otherwise error message
  String? validatePassword(String? password) {
    var isEmpty = password?.isEmpty ?? true;
    return isEmpty ? 'Password cannot be empty' : null;
  }

  /// Validate [repeatedPassword] passed by application user in text field
  /// Returns null if [repeatedPassword] properly validated. Otherwise error message
  String? validateRepeatedPassword(String? repeatedPassword) {
    var isEmpty = repeatedPassword?.isEmpty ?? true;
    if (isEmpty) {
      return 'Passwords must be equal';
    }
    var equal = repeatedPassword! == password;
    if (!equal) {
      return 'Passwords must be equal';
    }
    return null;
  }

  /// Set login as [loginToSet]
  void setLogin(String? loginToSet) {
    login = loginToSet ?? '';
  }

  /// Set password as [passwordToSet]
  void setPassword(String? passwordToSet) {
    password = passwordToSet ?? '';
  }

  /// Set repeated password as [repeatedPasswordToSet]
  void setRepeatedPassword(String? repeatedPasswordToSet) {
    repeatedPassword = repeatedPasswordToSet ?? '';
  }

  /// Main button onPressed action. Validates form data.
  /// If data are valid, then Welcome page is opened.
  Future<void> buttonValidator(BuildContext context) async {
    if (_creationKey.currentState?.validate() ?? false) {
      showLoadingDialog(context, 'Loading...');
      Future.delayed(const Duration(seconds: 1), () async {
        _hashData();
        await _addPossibleMissingObjects();
        await _addUserToDatabase();
        await _addTeacherOrStudentToDatabase();
        Navigator.of(context).pop();

        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
          if (teacher != null) {
            return WelcomePage(dbObject: teacher!);
          } else {
            return WelcomePage(dbObject: student!);
          }
        }));
      });
    }
  }

  void _hashData() {
    password = getHashedPassword(password);
  }

  /// Method adds topic, tool and place objects
  /// which are not already present in database
  Future<void> _addPossibleMissingObjects() async {
    if (teacher != null) {
      final topics = teacher?.topics ?? [];
      final tools = teacher?.tools ?? [];
      final places = teacher?.places ?? [];

      await dataManager.database.addTopics(topics);
      await dataManager.database.addTools(tools);
      await dataManager.database.addPlaces(places);
    }
  }

  /// Method adds user object to database
  /// This allows to log in using user's login and password
  Future<void> _addUserToDatabase() async {
    final isTeacher = teacher != null;
    final user = User(login, false, isTeacher, password);

    await dataManager.database.addUser(user);
  }

  /// Method adds student/teacher object to database
  /// Such objects will be retrived later e.g. in home pages
  Future<void> _addTeacherOrStudentToDatabase() async {
    if (teacher != null) {
      teacher?.userId = login;
      await dataManager.database.addTeacher(teacher!);
    } else {
      student?.userId = login;
      await dataManager.database.addStudent(student!);
    }
  }
}
