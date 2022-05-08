import 'package:teachent_app/common/consts.dart'
    show DatabaseConsts, DatabaseObjectName;
import 'package:teachent_app/common/date.dart';
import 'package:teachent_app/common/enums.dart';
import 'package:teachent_app/common/enum_functions.dart';

import 'db_object.dart';
import 'notification_field.dart';

/// Notification with most important values
/// [userId] - notification for user with [userId]
/// [title], [payload] - notification title and payload
class UserToNotifications extends DatabaseObject {
  final KeyId userId;
  final List<NotificationField> fields;

  UserToNotifications(this.userId, this.fields);

  UserToNotifications.fromMap(this.userId, Map<dynamic, dynamic> values)
      : fields = values.entries.map((n) => NotificationField.fromMap(n.key, n.value)).toList();

  @override
  String get collectionName => DatabaseObjectName.userToNotifications;

  @override
  String get key => userId;

  @override
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'fields': {for (final field in fields) field.key: field.toMap()},
    };
  }
}
