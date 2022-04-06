import 'package:teachent_app/common/consts.dart'
    show DatabaseConsts, DatabaseObjectName;
import 'package:teachent_app/model/db_objects/db_object.dart';

import '../objects/place.dart';
import '../objects/tool.dart';
import '../objects/topic.dart';

class Teacher extends DatabaseObject {
  KeyId userId = DatabaseConsts.emptyKey;
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

  Teacher.noKey(this.name, this.description, this.topics, this.tools,
      this.places, this.averageRate, this.requests, this.lessonDates);

  // TODO - Remove this
  Teacher.onlyKeyName(this.userId, this.name)
      : description = '',
        topics = [],
        tools = [],
        places = [],
        averageRate = -1,
        requests = [],
        lessonDates = [];

  @override
  String get collectionName => DatabaseObjectName.teachers;

  @override
  String get key => userId;

  @override
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'topics': {for (var topic in topics) topic.name: true},
      'tools': {for (var tool in tools) tool.name: true},
      'places': {for (var place in places) place.name: true},
      'averageRate': averageRate,
      'requests': {for (var key in requests) key: true},
      'lessonDates': {for (var date in lessonDates) date: true}
    };
  }
}
