import 'package:teachent_app/common/consts.dart'
    show DatabaseConsts, DatabaseObjectName;
import 'package:teachent_app/model/db_objects/db_object.dart';

import '../objects/place.dart';
import '../objects/tool.dart';

class LessonDate extends DatabaseObject {
  final KeyId lessonDateId;
  final KeyId teacherId;
  final KeyId studentId;
  final bool isFree;
  final String weekday;
  final String hourTime;
  final bool isCycled;
  final int price;
  final List<Tool> tools;
  final List<Place> places;

  LessonDate(
      this.lessonDateId,
      this.teacherId,
      this.studentId,
      this.isFree,
      this.weekday,
      this.hourTime,
      this.isCycled,
      this.price,
      this.tools,
      this.places);

  LessonDate.noKey(this.teacherId, this.studentId, this.isFree, this.weekday,
      this.hourTime, this.isCycled, this.price, this.tools, this.places)
      : lessonDateId = DatabaseConsts.emptyKey;

  @override
  String get collectionName => DatabaseObjectName.lessonDates;

  @override
  String get key => lessonDateId;

  @override
  Map<String, dynamic> toMap() {
    final map = <String, String>{};
    return map;
  }
}
