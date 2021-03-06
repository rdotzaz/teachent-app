import 'package:teachent_app/common/data_manager.dart';
import 'package:teachent_app/model/db_objects/lesson.dart';
import 'package:teachent_app/model/db_objects/report.dart';

/// Class for report management
class ReportManager {
  /// Create lesson report for [lesson] with [title] and [description]
  static Future<void> create(DataManager dataManager, Lesson lesson,
      String title, String description) async {
    final report = Report.noKey(
        lesson.lessonDateId, lesson.lessonId, title, description, lesson.date);
    final reportKey = await dataManager.database.addReport(report);
    await dataManager.database.updateReportId(lesson.lessonId, reportKey);
  }
}
