import 'package:teachent_app/controller/controller.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';
import 'package:teachent_app/model/db_objects/teacher.dart';
import 'package:teachent_app/model/objects/topic.dart';
import 'package:teachent_app/model/objects/tool.dart';
import 'package:teachent_app/model/objects/place.dart';

class TeacherProfilePageController extends BaseController {
    final Teacher teacher;
    final KeyId studentId;

    TeacherProfilePageController(this.teacher, this.studentId);

    String get teacherName => teacher.name;
    String get description => teacher.description;

    bool get hasRate => teacher.averageRate != -1;
    int get rate => teacher.averageRate;

    List<Topic> get topics => teacher.topics;
    List<Tool> get tools => teacher.tools;
    List<Place> get places => teacher.places;
}