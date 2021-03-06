import 'package:flutter/material.dart';
import 'package:teachent_app/common/enums.dart';
import 'package:teachent_app/controller/controller.dart';
import 'package:teachent_app/model/db_objects/student.dart';
import 'package:teachent_app/model/db_objects/teacher.dart';
import 'package:teachent_app/view/pages/teacher_profile_page/teacher_profile_page.dart';
import 'package:teachent_app/view/pages/student_profile_page/student_profile_page.dart';

/// Controller for Teacher Search Page
class TeacherSearchPageController extends BaseSearchController {
  final List<Teacher> _foundTeachers = [];
  final List<Student> _foundStudents = [];

  /// Get found teachers
  List<Teacher> get teachers => _foundTeachers;

  /// Get found students
  List<Student> get students => _foundStudents;

  @override
  Future<void> updateFoundList(PersonType type) async {
    _foundTeachers.clear();
    _foundStudents.clear();

    if (type == PersonType.teachers || type == PersonType.all) {
      await _updateTeachers();
    }
    if (type == PersonType.students || type == PersonType.all) {
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

  /// Methods triggers [StudentProfilePage] for student from foundStudents array at [studentIndex]
  Future<void> goToStudentProfile(
      BuildContext context, int studentIndex) async {
    final student = _foundStudents[studentIndex];

    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => StudentProfilePage(student)));
  }

  /// Methods triggers [TeacherProfilePage] for teacher from foundTeachers array at [teacherIndex]
  Future<void> goToTeacherProfile(
      BuildContext context, int teacherIndex) async {
    final teacher = _foundTeachers[teacherIndex];

    await Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => TeacherProfilePage(teacher: teacher)));
  }
}
