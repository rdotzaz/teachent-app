import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:teachent_app/common/data_manager.dart';
import 'package:teachent_app/common/enums.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';
import 'package:teachent_app/model/db_objects/notification_field.dart';
import 'package:teachent_app/model/db_objects/user_to_notifications.dart';
import 'package:teachent_app/view/widgets/notification_bar.dart';

class NotificationManager {
    /// Based on https://pub.dev/packages/background_fetch example
    /// Callback for created backgorund task
    /// [TODO] Task is going to fetch data from database to check if
    ///        there is a new notification for logged user 
    static void _notificationBackgroundTask(HeadlessTask task) async {
        final taskId = task.taskId;
        if (task.timeout) {
            print('Headless task $taskId time-out');
            BackgroundFetch.finish(taskId);
        }
        await _checkNotifications();
        BackgroundFetch.finish(taskId);
    }

    static void register() {
        BackgroundFetch.registerHeadlessTask(
            _notificationBackgroundTask);
        /// Based on https://pub.dev/packages/awesome_notifications
        AwesomeNotifications().initialize(
            null,
            [
                NotificationChannel(
                    channelGroupKey: 'app_channel_group',
                    channelKey: 'app_channel',
                    channelName: 'Teachent Notifications',
                    channelDescription: 'Main notification channel',
                    defaultColor: Colors.white,
                    ledColor: Colors.white
                )
            ],
            debug: true
        );
    }

    static void setRequestPermissionResult(bool isAccepted) async {
        if (!isAccepted) {
            AwesomeNotifications().requestPermissionToSendNotifications();
        }
    }

    static Future<bool> isNotificationsAlreadyPermitted() async {
        return AwesomeNotifications().isNotificationAllowed();
    }

    /// Based on https://pub.dev/packages/awesome_notifications
    static void startListen(BuildContext context) async {
        AwesomeNotifications().actionStream.listen(
            (notification) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => NotificationBar()
                ));
            }
        );
    }

    /// Based on https://pub.dev/packages/background_fetch example
    /// Configure background task to fetch data from database every 15 minutes*
    ///
    /// *15 minutes interval is the lowest value allowed by system Android to run
    /// background task
    static Future<int> configure() async {
        final configStatus = await BackgroundFetch.configure(BackgroundFetchConfig(
            minimumFetchInterval: 15,
            stopOnTerminate: false,
            startOnBoot: true,
            enableHeadless: true,
            requiresBatteryNotLow: true,
            requiredNetworkType: NetworkType.ANY
        ), (taskId) async {
            await _checkNotifications();
            BackgroundFetch.finish(taskId);
        }, (taskId) {
            print('TIMEOUT task $taskId');
            BackgroundFetch.finish(taskId);
        });
        return configStatus;
    }

    static Future<void> _checkNotifications() async {
        final dataManager = DataManagerCreator.create();
        if (dataManager.database.isAppConfigurationAlreadyExists()) {
            final appConfiguration = dataManager.database.getAppConfiguration();
            final userId = appConfiguration.userId;

            final notificationEntity = await dataManager.database.getCheckNotificationsByUserId(userId);

            if (notificationEntity == NotificationStatus.present) {
                final userToNotifications = await dataManager.database.getNotificationsByUserId(userId);
                (userToNotifications.fields).forEach((field) => showNotification(field));
            }
        }
    }

    static void showNotification(NotificationField field) async {
        /// TODO - Add logic for showing notifications on device
    }
    
    static void send(DataManager dataManager, KeyId receiverUserId, NotificationField field) async {
        await dataManager.database.sendNotification(receiverUserId, field);
    }
}
