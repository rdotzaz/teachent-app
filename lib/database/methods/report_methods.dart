import 'package:teachent_app/common/consts.dart';
import 'package:teachent_app/database/database.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';
import 'package:teachent_app/model/db_objects/date_to_reports.dart';
import 'package:teachent_app/model/db_objects/report.dart';

/// Methods to maintain Report object in database
mixin ReportDatabaseMethods on IDatabase {
  /// Returns all reports with [lessonDateId]
  Future<List<Report>> getReportsByLessonDateId(KeyId lessonDateId) async {
    final reportsValues = await firebaseAdapter.getObject(
        DatabaseObjectName.dateToReports, lessonDateId);
    final dateToReports = DateToReports.fromMap(lessonDateId, reportsValues);

    final reports = <Report>[];
    for (final id in dateToReports.reportIds) {
      final reportValues = await firebaseAdapter.getObject(
          DatabaseObjectName.reports, id);
      reports.add(Report.fromMap(id, reportValues));
    }
    return reports;
  }

  /// Get report with [lessonId]
  /// If such report does not exist, return null
  Future<Report?> getReport(KeyId reportId) async {
    final reportValues = await firebaseAdapter.getObject(
        DatabaseObjectName.reports, reportId);
    if (reportValues.isEmpty) {
      return null;
    }
    return Report.fromMap(reportId, reportValues);
  }

  Future<KeyId> addReport(Report report) async {
    final key =
        await firebaseAdapter.addDatabaseObjectWithNewKey(
            DatabaseObjectName.reports, report.toMap());
    await firebaseAdapter.updateMapField(
        DatabaseObjectName.dateToReports, report.lessonDateId, {key: true});
    return key;
  }
}
