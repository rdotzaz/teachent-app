import 'package:teachent_app/controller/controller.dart';
import 'package:teachent_app/model/db_objects/student.dart';

/// Controller for student profile page
class StudentProfilePageController extends BaseController {
  final Student student;
  StudentProfilePageController(this.student);

  /// Return name of the student
  String get name => student.name;

  /// Return education level string representation
  String get educationLevel => student.educationLevel.name;
}
