import 'package:teachent_app/common/consts.dart'
    show DatabaseConsts, DatabaseObjectName;
import 'package:teachent_app/common/date.dart';
import 'package:teachent_app/common/enums.dart';
import 'package:teachent_app/common/enum_functions.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';

/// Notification with most important values
/// [userId] - notification for user with [userId]
/// [title], [payload] - notification title and payload
class NotificationField extends DatabaseObject {
  final KeyId notificationId;
  final NotificationAction action;
  final String title;
  final String payload;

  NotificationField(this.notificationId, this.action, this.title,
      this.payload);

  NotificationField.noKey(this.action, this.title, this.payload)
      : notificationId = DatabaseConsts.emptyKey;

  NotificationField.fromMap(this.notificationId, Map<dynamic, dynamic> values)
      : action = getActionByValue(values['action'] ?? 0),
        title = values['title'] ?? '',
        payload = values['payload'] ?? '';

  @override
  String get collectionName => '?';

  @override
  String get key => notificationId;

  @override
  Map<String, dynamic> toMap() {
    return {
      'action': action.value,
      'title': title,
      'payload': payload
    };
  }
}
