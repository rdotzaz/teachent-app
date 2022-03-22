import '../../model/db_objects/db_object.dart';
import '../../model/db_objects/student.dart';

mixin StudentDatabaseMethods {
  void addStudent(Student student) {}

  void update(KeyId studentId) {}

  void deleteStudent(KeyId studentId) {}
}
