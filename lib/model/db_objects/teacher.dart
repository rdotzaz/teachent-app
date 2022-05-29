import 'package:teachent_app/common/consts.dart'
    show DatabaseConsts, DatabaseObjectName;
import 'package:teachent_app/model/db_objects/db_object.dart';

import '../objects/place.dart';
import '../objects/tool.dart';
import '../objects/topic.dart';

/// Object representation of teacher (person who can lead private lessons)
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
  final List<KeyId> reviews;

  Teacher(
      this.userId,
      this.name,
      this.description,
      this.topics,
      this.tools,
      this.places,
      this.averageRate,
      this.requests,
      this.lessonDates,
      this.reviews);

  Teacher.noKey(
      this.name,
      this.description,
      this.topics,
      this.tools,
      this.places,
      this.averageRate,
      this.requests,
      this.lessonDates,
      this.reviews)
      : userId = DatabaseConsts.emptyKey;

  Teacher.onlyKeyName(
      this.userId, this.name, this.topics, this.tools, this.places)
      : description = '',
        averageRate = 0,
        requests = [],
        lessonDates = [],
        reviews = [];

  Teacher.fromMap(this.userId, Map<dynamic, dynamic> values)
      : name = values['name'] ?? '',
        description = values['description'] ?? '',
        topics = DatabaseObject.getMapFromField(values, 'topics')
            .entries
            .map((t) => Topic(t.key, true))
            .toList(),
        tools = DatabaseObject.getMapFromField(values, 'tools')
            .entries
            .map((t) => Tool(t.key, true))
            .toList(),
        places = DatabaseObject.getMapFromField(values, 'places')
            .entries
            .map((p) => Place(p.key, true))
            .toList(),
        averageRate = values['averageRate'] as int? ?? 0,
        requests = DatabaseObject.getMapFromField(values, 'requests')
            .entries
            .map((id) => id.key)
            .toList(),
        lessonDates = DatabaseObject.getMapFromField(values, 'lessonDates')
            .entries
            .map((id) => id.key)
            .toList(),
        reviews = DatabaseObject.getMapFromField(values, 'reviews')
            .entries
            .map((id) => id.key)
            .toList();

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
      'lessonDates': {for (var date in lessonDates) date: true},
      'reviews': {for (var review in reviews) review: true}
    };
  }
}
