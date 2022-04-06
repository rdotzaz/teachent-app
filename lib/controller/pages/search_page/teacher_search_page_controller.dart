import 'package:teachent_app/controller/controller.dart';
import 'package:teachent_app/model/db_objects/student.dart';
import 'package:teachent_app/model/db_objects/teacher.dart';

class TeacherSearchPageController extends BaseSearchController {
  final List<Teacher> _foundTeachers = [];
  final List<Student> _foundStudents = [];

  List<Teacher> get teachers => _foundTeachers;
  List<Student> get students => _foundStudents;

  Future<void> updateTeachers() async {
    _foundTeachers.clear();
    final teachers = await dataManager.database.getTeachersByNamePart(phrase);
    _foundTeachers.addAll(teachers);
  }

  Future<void> updateStudents() async {
    _foundStudents.clear();
    final students = await dataManager.database.getStudentsByNamePart(phrase);
    _foundStudents.addAll(students);
  }
}
