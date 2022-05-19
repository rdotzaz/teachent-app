import 'package:teachent_app/common/consts.dart'
    show DatabaseObjectName;
import 'package:teachent_app/model/db_objects/db_object.dart';

class DateToReports extends DatabaseObject {
  final KeyId lessonDateId;
  final List<KeyId> reportIds;

  DateToReports(this.lessonDateId, this.reportIds);

  DateToReports.fromMap(this.lessonDateId, Map<dynamic, dynamic> values)
      : reportIds = values.keys.map((k) => k.toString()).toList();

  @override
  String get collectionName => DatabaseObjectName.dateToReports;

  @override
  String get key => lessonDateId;

  @override
  Map<String, dynamic> toMap() {
    return {for (final reportId in reportIds) reportId: true};
  }
}
