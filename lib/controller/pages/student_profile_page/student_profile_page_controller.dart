import 'package:teachent_app/controller/controller.dart';
import 'package:teachent_app/model/db_objects/student.dart';

class StudentProfilePageController extends BaseController {
  final Student student;
  StudentProfilePageController(this.student);

  String get name => student.name;
  String get educationLevel => student.educationLevel.name;
}
