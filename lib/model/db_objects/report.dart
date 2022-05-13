import 'package:teachent_app/common/consts.dart'
    show DatabaseConsts, DatabaseObjectName;
import 'package:teachent_app/common/date.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';

/// Object representation of report about finished lesson
class Report extends DatabaseObject {
  final KeyId reportId;
  final KeyId lessonId;
  final String title;
  final String description;
  final DateTime date;

  Report(this.reportId, this.lessonId, this.title, this.description, this.date);

  Report.noKey(this.lessonId, this.title, this.description, this.date)
      : reportId = DatabaseConsts.emptyKey;

  Report.withMap(this.reportId, Map<dynamic, dynamic> values)
      : lessonId = values['lessonId'] ?? '',
        title = values['title'] ?? '',
        description = values['description'] ?? '',
        date = DateFormatter.parse(values['date'] ?? '');

  @override
  String get collectionName => DatabaseObjectName.reports;

  @override
  String get key => reportId;

  @override
  Map<String, dynamic> toMap() {
    return {'lessonId': lessonId, 'title': title, 'description': description, 'date': DateFormatter.getString(date)};
  }
}
