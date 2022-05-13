import 'package:teachent_app/common/consts.dart';
import 'package:teachent_app/common/data_manager.dart';
import 'package:teachent_app/common/enums.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';
import 'package:teachent_app/model/db_objects/lesson.dart';
import 'package:teachent_app/model/db_objects/lesson_date.dart';
import 'package:teachent_app/model/db_objects/report.dart';

class ReportManager {
  static Future<void> create(
      DataManager dataManager,
      Lesson lesson,
      String title,
      String description) async {
    final report = Report.noKey(lesson.lessonId, title, description, lesson.date);
    // TODO - add report
  }
}
