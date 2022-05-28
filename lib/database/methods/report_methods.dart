import 'package:teachent_app/common/consts.dart';
import 'package:teachent_app/common/firebase_enums.dart';
import 'package:teachent_app/database/adapters/firebase_adapter.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';
import 'package:teachent_app/model/db_objects/date_to_reports.dart';
import 'package:teachent_app/model/db_objects/report.dart';

/// Methods to maintain Report object in database
mixin ReportDatabaseMethods {
  /// Returns all reports with [lessonDateId]
  Future<List<Report>> getReportsByLessonDateId(KeyId lessonDateId) async {
    final response = await FirebaseRealTimeDatabaseAdapter.getObject(
        DatabaseObjectName.dateToReports, lessonDateId);

    if (response.status == FirebaseResponseStatus.failure) {
      return [];
    }

    final dateToReports = DateToReports.fromMap(lessonDateId, response.data);

    final reports = <Report>[];
    for (final id in dateToReports.reportIds) {
      final reportResponse = await FirebaseRealTimeDatabaseAdapter.getObject(
          DatabaseObjectName.reports, id);

      if (reportResponse.status == FirebaseResponseStatus.failure) {
        continue;
      }
      reports.add(Report.fromMap(id, reportResponse.data));
    }
    return reports;
  }

  /// Get report with [lessonId]
  /// If such report does not exist, return null
  Future<Report?> getReport(KeyId reportId) async {
    final response = await FirebaseRealTimeDatabaseAdapter.getObject(
        DatabaseObjectName.reports, reportId);
    if (response.status == FirebaseResponseStatus.failure) {
      return null;
    }
    return Report.fromMap(reportId, response.data);
  }

  Future<KeyId> addReport(Report report) async {
    final response =
        await FirebaseRealTimeDatabaseAdapter.addDatabaseObjectWithNewKey(
            DatabaseObjectName.reports, report.toMap());
    await FirebaseRealTimeDatabaseAdapter.updateMapField(
        DatabaseObjectName.dateToReports,
        report.lessonDateId,
        {response.data: true});
    return response.data;
  }
}
