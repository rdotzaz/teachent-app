import 'package:teachent_app/common/consts.dart' show DatabaseObjectName;
import 'package:teachent_app/model/db_objects/db_object.dart';

class Report extends DatabaseObject {
  final KeyId reportId;
  final KeyId lessonId;
  final String description;
  final String date;

  Report(this.reportId, this.lessonId, this.description, this.date);

  @override
  String get collectionName => DatabaseObjectName.reports;

  @override
  String get key => reportId;

  @override
  Map<String, dynamic> toMap() {
    final map = <String, String>{};
    return map;
  }
}
