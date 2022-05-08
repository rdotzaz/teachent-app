import 'package:teachent_app/common/consts.dart';
import 'package:teachent_app/common/enums.dart';
import 'package:teachent_app/common/enum_functions.dart';
import 'package:teachent_app/database/adapters/firebase_adapter.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';
import 'package:teachent_app/model/db_objects/notification_field.dart';
import 'package:teachent_app/model/db_objects/user_to_notifications.dart';

/// Methods to maintain notifications in database
mixin NotificationMethods {
  Future<NotificationEntity> getCheckNotificationsByUserId(KeyId userId) async {
    final notificationValue = await FirebaseRealTimeDatabaseAdapter.getValue<bool>(
        DatabaseObjectName.notifications, userId);
    if (notificationValue == null) {
        return NotificationEntity(
            userId: userId,
            status: NotificationStatus.none);
    }
    return NotificationEntity(
        userId: userId,
        status: notificationValue ? NotificationStatus.present : NotificationStatus.none
    );
  }

  Future<UserToNotifications> getNotificationsByUserId(KeyId userId) async {
      final notificationValues = await FirebaseRealTimeDatabaseAdapter.getObject(
          DatabaseObjectName.userToNotifications, userId);
      assert (notificationValues.isNotEmpty);
      /// 'kowalski: {
      ///   'nid1': {
      ///    'action': 'newRequest',
      ///    'title': 'You have new request',
      ///    'payload': '...'
      ///   },
      ///   'nid2': {...}
      /// }
      ///
      final List<NotificationField> fields = [];
      notificationValues.forEach((notificationId, values) {
          fields.add(NotificationField.fromMap(notificationId, values));
      });
      return UserToNotifications(userId, fields);
  }

  Future<void> sendNotification(KeyId receiverUserId, NotificationField field) async {
    await FirebaseRealTimeDatabaseAdapter.addSubObjectWithNewKey(
        DatabaseObjectName.userToNotifications, receiverUserId, field.toMap());
    await FirebaseRealTimeDatabaseAdapter.updateValue(
        DatabaseObjectName.notifications, receiverUserId, true);
  }
}
