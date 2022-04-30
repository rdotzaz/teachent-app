import 'package:teachent_app/common/consts.dart'
    show DatabaseConsts, DatabaseObjectName;
import 'package:teachent_app/model/db_objects/db_object.dart';

import '../objects/place.dart';
import '../objects/tool.dart';
import '../objects/topic.dart';

class TeacherToItemsMap extends DatabaseObject {
  final KeyId teacherId;
  final List<Topic> topics;
  final List<Tool> tools;
  final List<Place> places;

  TeacherToItemsMap(this.teacherId, this.topics, this.tools, this.places);

  factory TeacherToItemsMap.fromMap(
      KeyId teacherId, Map<dynamic, dynamic> values) {
    return TeacherToItemsMap(
        teacherId,
        (values['topics'] as Map<dynamic, dynamic>)
            .entries
            .map((t) => Topic(t.key, true))
            .toList(),
        (values['tools'] as Map<dynamic, dynamic>)
            .entries
            .map((t) => Tool(t.key, true))
            .toList(),
        (values['places'] as Map<dynamic, dynamic>)
            .entries
            .map((p) => Place(p.key, true))
            .toList());
  }

  @override
  String get collectionName => '';

  @override
  String get key => teacherId;

  @override
  Map<String, dynamic> toMap() {
    return {
      'topics': {for (final topic in topics) topic.name: true},
      'tools': {for (final tool in tools) tool.name: true},
      'places': {for (final place in places) place.name: true}
    };
  }
}
