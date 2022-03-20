import 'package:teachent_app/common/consts.dart' show DatabaseObjectName;
import 'package:teachent_app/model/db_objects/db_object.dart';

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

  @override
  String get collectionName => DatabaseObjectName.lessons;

  @override
  String get key => lessonDateId;

  @override
  Map<String, dynamic> toMap() {
    final map = <String, String>{};
    return map;
  }
}
