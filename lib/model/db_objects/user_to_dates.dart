import 'package:teachent_app/model/db_objects/db_object.dart';

class UserToDatesMap extends DatabaseObject {
  final KeyId userId;
  final List<KeyId> lessonDateIds;

  UserToDatesMap(this.userId, this.lessonDateIds);

  UserToDatesMap.fromMap(this.userId, Map<dynamic, dynamic> values)
      : lessonDateIds = DatabaseObject.getMapFromField(values, 'lessonDateIds')
            .entries
            .map((id) => id.key)
            .toList();

  @override
  String get collectionName => '';

  @override
  String get key => userId;

  @override
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'lessonDateIds': {for (final dateId in lessonDateIds) dateId: true}
    };
  }
}
