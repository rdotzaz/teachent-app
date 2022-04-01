import 'package:teachent_app/controller/controller.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';
import 'package:teachent_app/model/db_objects/teacher.dart';

class TeacherHomePageController extends BaseController {
  final KeyId userId;
  late Teacher teacher;

  TeacherHomePageController(this.userId);

  @override
  Future<void> init() async {
    final possibleTeacher = await dataManager.database.getTeacher(userId);
    if (possibleTeacher == null) {
      // TODO - Raise error
      print('ERROR: Teacher not found');
      return;
    }
    print('After getTeacher');
    teacher = possibleTeacher;
  }

  String get teacherName => teacher.name;
}
