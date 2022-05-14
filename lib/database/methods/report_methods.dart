import 'package:teachent_app/common/consts.dart';
import 'package:teachent_app/database/adapters/firebase_adapter.dart';
import 'package:teachent_app/database/database.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';
import 'package:teachent_app/model/db_objects/date_to_reports.dart';
import 'package:teachent_app/model/db_objects/report.dart';

/// Methods to maintain Report object in database
mixin ReportDatabaseMethods {
  /// Returns all reports with [lessonDateId]
  Future<List<Report>> getReportsByLessonDateId(KeyId lessonDateId) async {
    final reportsValues = await FirebaseRealTimeDatabaseAdapter.getObject(
        DatabaseObjectName.dateToReports, lessonDateId);
    final dateToReports = DateToReports.fromMap(lessonDateId, reportsValues);

    final reports = <Report>[];
    dateToReports.reportIds.forEach((id) async {
        final reportValues = await FirebaseRealTimeDatabaseAdapter.getObject(
            DatabaseObjectName.reports, id);
        reports.add(Report.fromMap(id, reportValues));
    });
    return reports;
  }

  Future<KeyId> addReport(Report report) async {
    final key = await FirebaseRealTimeDatabaseAdapter.addDatabaseObjectWithNewKey(
        DatabaseObjectName.reports, report.toMap());
    await FirebaseRealTimeDatabaseAdapter.updateMapField(
      DatabaseObjectName.dateToReports, report.lessonDateId, {key: true});
    return key;
  }
}
