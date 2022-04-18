import 'package:teachent_app/common/consts.dart'
    show DatabaseConsts, DatabaseObjectName;
import 'package:teachent_app/model/db_objects/db_object.dart';

class UserToDatesMap extends DatabaseObject {
  final KeyId userId;
  final List<KeyId> lessonDateIds;

  UserToDatesMap(this.userId, this.lessonDateIds);

  factory UserToDatesMap.fromMap(KeyId userId, Map<dynamic, dynamic> values) {
    return UserToDatesMap(
        userId,
        (values['lessonDateIds'] as Map<dynamic, dynamic>)
            .entries
            .map((id) => id.key as String)
            .toList());
  }

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
