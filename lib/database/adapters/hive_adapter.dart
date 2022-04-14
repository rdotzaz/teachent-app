import 'dart:developer' as dev;

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

  static void clear() {
    var configBox = Hive.box(HiveConsts.hiveConfigBox);
    configBox.clear();
  }

  /// Returns true if configuration already exists in local database
  static bool hasConfiguration() {
    var configBox = Hive.box(HiveConsts.hiveConfigBox);
    if (!configBox.isOpen) {
      return false;
    }
    return configBox.get(HiveConsts.userId) != null &&
        configBox.get(HiveConsts.themeMode) != null &&
        configBox.get(HiveConsts.userMode) != null;
  }

  /// Add [values] to configuration box in Hive local database
  static void putConfiguration(DBValues values) {
    var configBox = Hive.box(HiveConsts.hiveConfigBox);
    if (!configBox.isOpen) {
      dev.log('[HiveAdapter] Trying to add configuration to closed box');
      return;
    }

    if (!values['userId']) {
      dev.log('[HiveAdapter] Put configuration with empty userId');
    }
    if (!values['themeMode']) {
      dev.log('[HiveAdapter] Put configuration with empty themeMode');
    }
    if (!values['userMode']) {
      dev.log('[HiveAdapter] Put configuration with empty userMode');
    }

    configBox.put(HiveConsts.userId, values['userId'] ?? '');
    configBox.put(HiveConsts.themeMode, values['themeMode']);
    configBox.put(HiveConsts.userMode, values['userMode']);
  }

  /// Returns map representation of AppConfiguration object of existing configuration
  static DBValues getConfiguration() {
    var configBox = Hive.box(HiveConsts.hiveConfigBox);
    if (!configBox.isOpen) {
      dev.log('[HiveAdapter] Trying to retrive configuration from closed box');
      return {};
    }

    var userId = configBox.get(HiveConsts.userId);
    var themeMode = configBox.get(HiveConsts.themeMode);
    var userMode = configBox.get(HiveConsts.userMode);

    return {'userId': userId, 'themeMode': themeMode, 'userMode': userMode};
  }
}
