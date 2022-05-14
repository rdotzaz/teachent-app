import 'package:teachent_app/common/date.dart';
import 'package:teachent_app/common/enum_functions.dart';
import 'package:teachent_app/controller/controller.dart';
import 'package:teachent_app/model/db_objects/lesson_date.dart';
import 'package:teachent_app/model/db_objects/report.dart';
import 'package:teachent_app/model/db_objects/teacher.dart';
import 'package:teachent_app/model/db_objects/student.dart';
import 'package:teachent_app/model/objects/place.dart';
import 'package:teachent_app/model/objects/tool.dart';

class LessonDatePageController extends BaseController {
  final LessonDate lessonDate;
  final bool isTeacher;
  LessonDatePageController(this.lessonDate, this.isTeacher);

  late Teacher teacher;
  late Student student;
  final List<Report> reports = [];

  bool get isNotFree => !lessonDate.isFree;
  String get studentName => student.name;
  String get teacherName => teacher.name;
  String get cycleType => lessonDate.cycleType.stringValue;
  String get price => lessonDate.price.toString();
  String get startDate => DateFormatter.getString(lessonDate.date);
  List<Tool> get tools => lessonDate.tools;
  List<Place> get places => lessonDate.places;
  bool get areReports => reports.isNotEmpty;

  @override
  Future<void> init() async {
    reports.clear();
    final foundReports = await dataManager.database
        .getReportsByLessonDateId(lessonDate.lessonDateId);
    reports.addAll(foundReports);

    final foundStudent =
        await dataManager.database.getStudent(lessonDate.studentId);

    if (foundStudent == null) {
      print('ERROR: No student found');
      return;
    }
    student = foundStudent;

    final foundTeacher =
        await dataManager.database.getTeacher(lessonDate.teacherId);

    if (foundTeacher == null) {
      print('ERROR: No teacher found');
      return;
    }
    teacher = foundTeacher;
  }
}
