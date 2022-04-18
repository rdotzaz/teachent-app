import 'package:teachent_app/controller/controller.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';
import 'package:teachent_app/model/db_objects/lesson_date.dart';
import 'package:teachent_app/model/db_objects/teacher.dart';
import 'package:teachent_app/model/objects/topic.dart';
import 'package:teachent_app/model/objects/tool.dart';
import 'package:teachent_app/model/objects/place.dart';

class TeacherProfilePageController extends BaseController {
  final Teacher teacher;
  final KeyId studentId;

  final List<LessonDate> lessonDates = [];

  TeacherProfilePageController(this.teacher, this.studentId);

  Future<void> initDates() async {
    final dates =
        await dataManager.database.getLessonDates(teacher.lessonDates);
    lessonDates.addAll(dates);
  }

  String get teacherName => teacher.name;
  String get description => teacher.description;

  bool get hasRate => teacher.averageRate != -1;
  int get rate => teacher.averageRate;

  List<Topic> get topics => teacher.topics;
  List<Tool> get tools => teacher.tools;
  List<Place> get places => teacher.places;
}