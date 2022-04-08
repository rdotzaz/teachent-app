import 'package:teachent_app/controller/controller.dart';
import 'package:teachent_app/model/db_objects/student.dart';
import 'package:teachent_app/model/db_objects/teacher.dart';

class TeacherSearchPageController extends BaseSearchController {
  final List<Teacher> _foundTeachers = [];
  final List<Student> _foundStudents = [];

  List<Teacher> get teachers => _foundTeachers;
  List<Student> get students => _foundStudents;

  @override
  Future<void> updateFoundList(PersonType personType) async {
    _foundTeachers.clear();
    _foundStudents.clear();

    if (personType == PersonType.teachers || personType == PersonType.all) {
      await _updateTeachers();
    }
    if (personType == PersonType.students || personType == PersonType.all) {
      await _updateStudents();
    }
  }

  Future<void> _updateTeachers() async {
    final teachers = await dataManager.database.getTeachersByNamePart(phrase);
    _foundTeachers.addAll(teachers);
  }

  Future<void> _updateStudents() async {
    final students = await dataManager.database.getStudentsByNamePart(phrase);
    _foundStudents.addAll(students);
  }
}
