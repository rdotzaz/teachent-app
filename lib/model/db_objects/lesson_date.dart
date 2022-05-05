import 'package:intl/intl.dart';
import 'package:teachent_app/common/consts.dart'
    show DatabaseConsts, DatabaseObjectName;
import 'package:teachent_app/common/date.dart';
import 'package:teachent_app/common/enums.dart';
import 'package:teachent_app/common/enum_functions.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';

import '../objects/place.dart';
import '../objects/tool.dart';

/// Object representation of lesson record.
/// Contains information about teacher and student collaboration
/// It is general representation of lesson. It does not relate to exact lesson
class LessonDate extends DatabaseObject {
  final KeyId lessonDateId;
  final KeyId teacherId;
  final KeyId studentId;
  final bool isFree;
  final DateTime date;
  final bool isCycled;
  final CycleType cycleType;
  final int price;
  final List<Tool> tools;
  final List<Place> places;

  LessonDate(
      this.lessonDateId,
      this.teacherId,
      this.studentId,
      this.isFree,
      this.date,
      this.isCycled,
      this.cycleType,
      this.price,
      this.tools,
      this.places);

  LessonDate.init(this.teacherId, this.date, this.isCycled,
      this.cycleType, this.price, this.tools, this.places)
      : lessonDateId = DatabaseConsts.emptyKey,
        studentId = DatabaseConsts.emptyKey,
        isFree = true;

  LessonDate.noKey(
      this.teacherId,
      this.studentId,
      this.isFree,
      this.date,
      this.isCycled,
      this.cycleType,
      this.price,
      this.tools,
      this.places)
      : lessonDateId = DatabaseConsts.emptyKey;

  LessonDate.fromMap(this.lessonDateId, Map<dynamic, dynamic> values)
      : teacherId = values['teacherId'] ?? '',
        studentId = values['studentId'] ?? '',
        isFree = values['isFree'] ?? true,
        date = DateFormatter.parse(values['date']),
        isCycled = values['isCycled'] ?? false,
        cycleType = getCycleByValue(values['cycleType'] ?? -1),
        price = values['price'] ?? '',
        tools = DatabaseObject.getMapFromField(values, 'tools')
            .entries
            .map((t) => Tool(t.key, true))
            .toList(),
        places = DatabaseObject.getMapFromField(values, 'places')
            .entries
            .map((p) => Place(p.key, true))
            .toList();

  @override
  String get collectionName => DatabaseObjectName.lessonDates;

  @override
  String get key => lessonDateId;

  @override
  Map<String, dynamic> toMap() {
    return {
      'teacherId': teacherId,
      'studentId': studentId,
      'isFree': isFree,
      'date': DateFormatter.getString(date),
      'isCycled': isCycled,
      'cycleType': cycleType.value,
      'price': price,
      'tools': {for (final tool in tools) tool.name: true},
      'places': {for (final place in places) place.name: true}
    };
  }
}
