import 'package:teachent_app/common/consts.dart' show DatabaseObjectName;
import 'package:teachent_app/model/db_objects/db_object.dart';

import '../objects/place.dart';
import '../objects/tool.dart';
import '../objects/topic.dart';

class Teacher extends DatabaseObject {
  final KeyId userId;
  final String name;
  final String description;
  final List<Topic> topics;
  final List<Tool> tools;
  final List<Place> places;
  final int averageRate;
  final List<KeyId> requests;
  final List<KeyId> lessonDates;

  Teacher(this.userId, this.name, this.description, this.topics, this.tools,
      this.places, this.averageRate, this.requests, this.lessonDates);

  @override
  String get collectionName => DatabaseObjectName.teachers;

  @override
  String get key => userId;

  @override
  Map<String, dynamic> toMap() {
    final map = <String, String>{};
    return map;
  }
}
