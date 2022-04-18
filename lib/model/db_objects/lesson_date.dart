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

  LessonDate.init(this.teacherId, this.weekday, this.hourTime, this.isCycled,
      this.price, this.tools, this.places)
      : lessonDateId = DatabaseConsts.emptyKey,
        studentId = DatabaseConsts.emptyKey,
        isFree = true;

  LessonDate.noKey(this.teacherId, this.studentId, this.isFree, this.weekday,
      this.hourTime, this.isCycled, this.price, this.tools, this.places)
      : lessonDateId = DatabaseConsts.emptyKey;

  LessonDate.fromMap(this.lessonDateId, Map<dynamic, dynamic> values)
      : teacherId = values['teacherId'] ?? '',
        studentId = values['studentId'] ?? '',
        isFree = values['isFree'] ?? true,
        weekday = values['weekDay'] ?? '',
        hourTime = values['hourTime'] ?? '',
        isCycled = values['isCycled'] ?? false,
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
      'weekDay': weekday,
      'hourTime': hourTime,
      'isCycled': isCycled,
      'price': price,
      'tools': {for (final tool in tools) tool.name: true},
      'places': {for (final place in places) place.name: true}
    };
  }
}
