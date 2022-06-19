import 'package:hive_flutter/hive_flutter.dart';
import 'package:teachent_app/common/consts.dart';
import 'package:teachent_app/database/database.dart';

/// Class with static methods to communicate with local Hive database
class HiveDatabaseAdapter {
  /// Methods initializes local database and configuration box.
  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(HiveConsts.hiveConfigBox);
  }

  /// Clear hive boxes
  static void clear() {
    final configBox = Hive.box(HiveConsts.hiveConfigBox);
    configBox.clear();
  }

  /// Returns true if configuration already exists in local database
  static bool hasConfiguration() {
    final configBox = Hive.box(HiveConsts.hiveConfigBox);
    if (!configBox.isOpen) {
      return false;
    }
    return configBox.get(HiveConsts.userId) != null &&
        configBox.get(HiveConsts.themeMode) != null &&
        configBox.get(HiveConsts.userMode) != null;
  }

  /// Add [values] to configuration box in Hive local database
  static void putConfiguration(DBValues values) {
    final configBox = Hive.box(HiveConsts.hiveConfigBox);
    if (!configBox.isOpen) {
      return;
    }

    configBox.put(HiveConsts.userId, values[HiveConsts.userId] ?? '');
    configBox.put(HiveConsts.themeMode, values[HiveConsts.themeMode] ?? false);
    configBox.put(HiveConsts.userMode, values[HiveConsts.userMode] ?? true);
  }

  /// Returns map representation of AppConfiguration object of existing configuration
  static DBValues getConfiguration() {
    final configBox = Hive.box(HiveConsts.hiveConfigBox);
    if (!configBox.isOpen) {
      return {};
    }

    final userId = configBox.get(HiveConsts.userId);
    final themeMode = configBox.get(HiveConsts.themeMode);
    final userMode = configBox.get(HiveConsts.userMode);

    return {
      HiveConsts.userId: userId,
      HiveConsts.themeMode: themeMode,
      HiveConsts.userMode: userMode
    };
  }

  /// Remove app configuration from local database
  /// User has to log in next time to access thier account
  static void removeConfiguration() {
    final configBox = Hive.box(HiveConsts.hiveConfigBox);
    if (!configBox.isOpen) {
      return;
    }
    configBox.put(HiveConsts.userId, null);
    configBox.put(HiveConsts.themeMode, null);
    configBox.put(HiveConsts.userMode, null);
  }
}
