import 'package:teachent_app/common/consts.dart'
    show DatabaseConsts, DatabaseObjectName;
import 'package:teachent_app/model/db_objects/db_object.dart';

import '../objects/place.dart';
import '../objects/tool.dart';

class DatesToToolsPlacesMap extends DatabaseObject {
  final KeyId lessonDateId;
  final List<Tool> tools;
  final List<Place> places;

  DatesToToolsPlacesMap(this.lessonDateId, this.tools, this.places);

  factory DatesToToolsPlacesMap.fromMap(
      KeyId lessonDateId, Map<dynamic, dynamic> values) {
    return DatesToToolsPlacesMap(
        lessonDateId,
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
  String get key => lessonDateId;

  @override
  Map<String, dynamic> toMap() {
    return {
      'tools': {for (final tool in tools) tool.name: true},
      'places': {for (final place in places) place.name: true}
    };
  }
}
