import 'package:teachent_app/common/consts.dart'
    show DatabaseConsts, DatabaseObjectName;
import 'package:teachent_app/model/db_objects/db_object.dart';

/// Object representation of next lesson
/// Contains information of next lesson between teacher and student
class Lesson extends DatabaseObject {
  final KeyId lessonDateId;
  final KeyId teacherId;
  final KeyId studentId;
  final String date;
  final bool isPlanned;
  final bool isFinished;
  final List<KeyId> reports;

  Lesson(this.lessonDateId, this.teacherId, this.studentId, this.date,
      this.isPlanned, this.isFinished, this.reports);

  Lesson.noKey(this.teacherId, this.studentId, this.date, this.isPlanned,
      this.isFinished, this.reports)
      : lessonDateId = DatabaseConsts.emptyKey;

  Lesson.fromMap(this.lessonDateId, Map<dynamic, dynamic> values)
      : teacherId = values['teacherId'] ?? '',
        studentId = values['studentId'] ?? '',
        date = values['date'] ?? '',
        isPlanned = values['isPlanned'] ?? false,
        isFinished = values['isFinished'] ?? false,
        reports = DatabaseObject.getMapFromField(values, 'reports')
            .entries
            .map((r) => r.key)
            .toList();

  @override
  String get collectionName => DatabaseObjectName.lessons;

  @override
  String get key => lessonDateId;

  @override
  Map<String, dynamic> toMap() {
    return {
      'teacherId': teacherId,
      'studentId': studentId,
      'date': date,
      'isPlanned': isPlanned,
      'isFinished': isFinished,
      'reports': {for (final reportId in reports) reportId: true}
    };
  }
}
