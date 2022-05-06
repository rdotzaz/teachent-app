import 'package:intl/intl.dart';
import 'package:teachent_app/common/consts.dart'
    show DatabaseConsts, DatabaseObjectName;
import 'package:teachent_app/common/date.dart';
import 'package:teachent_app/common/enums.dart';
import 'package:teachent_app/common/enum_functions.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';

/// Object representation of next lesson
/// Contains information of next lesson between teacher and student
class Lesson extends DatabaseObject {
  final KeyId lessonId;
  final KeyId lessonDateId;
  final KeyId teacherId;
  final KeyId studentId;
  final DateTime date;
  final LessonStatus status;
  final KeyId reportId;

  Lesson(this.lessonId, this.lessonDateId, this.teacherId, this.studentId, this.date,
      this.status, this.reportId);

  Lesson.noKey(
      this.lessonDateId, this.teacherId, this.studentId, this.date, this.status, this.reportId)
      : lessonId = DatabaseConsts.emptyKey;

  Lesson.fromMap(this.lessonId, Map<dynamic, dynamic> values)
      : lessonDateId = values['lessonDateId'] ?? '', 
        teacherId = values['teacherId'] ?? '',
        studentId = values['studentId'] ?? '',
        date = DateFormatter.parse(values['date']),
        status = values['status'] ?? 0,
        reportId = values['reportId'] ?? '';

  @override
  String get collectionName => DatabaseObjectName.lessons;

  @override
  String get key => lessonId;

  @override
  Map<String, dynamic> toMap() {
    return {
      'lessonDateId': lessonDateId,
      'teacherId': teacherId,
      'studentId': studentId,
      'date': DateFormatter.getString(date),
      'status': status.value,
      'reportId': reportId
    };
  }
}
