import 'package:flutter/material.dart';
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
      print('Unknown type of dbObject ${dbObject.runtimeType}');
    }
  }

  @override
  void dispose() {}

  String get profileName => teacher != null ? 'Teacher' : 'Student';
  String get name {
    return teacher?.name ?? student?.name ?? '';
  }

  String? validateLogin(String? login) {
    var isEmpty = login?.isEmpty ?? true;
    return isEmpty ? 'Login cannot be empty' : null;
  }

  String? validatePassword(String? password) {
    var isEmpty = password?.isEmpty ?? true;
    return isEmpty ? 'Password cannot be empty' : null;
  }

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

  void setLogin(String? loginToSet) {
    login = loginToSet ?? '';
  }

  void setPassword(String? passwordToSet) {
    password = passwordToSet ?? '';
  }

  void setRepeatedPassword(String? repeatedPasswordToSet) {
    repeatedPassword = repeatedPasswordToSet ?? '';
  }

  Future<void> buttonValidator(BuildContext context) async {
    if (_creationKey.currentState?.validate() ?? false) {
      await addPossibleMissingObjects();
      await addUserToDatabase();
      await addTeacherOrStudentToDatabase();

      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
        if (teacher != null) {
          return WelcomePage(dbObject: teacher!);
        } else {
          return WelcomePage(dbObject: student!);
        }
      }));
    }
  }

  /// Method adds topic, tool and place objects
  /// which are not already present in database
  Future<void> addPossibleMissingObjects() async {
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
  Future<void> addUserToDatabase() async {
    final isTeacher = teacher != null;
    final user = User(login, false, isTeacher, password);

    await dataManager.database.addUser(user);
  }

  /// Method adds student/teacher object to database
  /// Such objects will be retrived later e.g. in home pages
  Future<void> addTeacherOrStudentToDatabase() async {
    if (teacher != null) {
      teacher?.userId = login;
      await dataManager.database.addTeacher(teacher!);
    } else {
      student?.userId = login;
      await dataManager.database.addStudent(student!);
    }
  }
}
