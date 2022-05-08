import 'package:background_fetch/background_fetch.dart';

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
        print('Working...');
        BackgroundFetch.finish(taskId);
    }

    static void register() {
        BackgroundFetch.registerHeadlessTask(
            _notificationBackgroundTask);
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
        ), (taskId) {
            print('EVENT received $taskId');
            BackgroundFetch.finish(taskId);
        }, (taskId) {
            BackgroundFetch.finish(taskId);
        });
        return configStatus;
    }
}
