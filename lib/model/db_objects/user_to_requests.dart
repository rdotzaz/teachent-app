import 'package:teachent_app/common/consts.dart'
    show DatabaseConsts, DatabaseObjectName;
import 'package:teachent_app/model/db_objects/db_object.dart';

class UserToRequstsMap extends DatabaseObject {
  final KeyId userId;
  final List<KeyId> requestIds;

  UserToRequstsMap(
      this.userId,
      this.requestIds);

  factory UserToRequstsMap.fromMap(KeyId userId, Map<dynamic, dynamic> values) {
    return UserToRequstsMap(
        userId,
        (values['requestIds'] as Map<dynamic, dynamic>)
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
      'requestIds': {for (final requestId in requestIds) requestId: true}
    };
  }
}
