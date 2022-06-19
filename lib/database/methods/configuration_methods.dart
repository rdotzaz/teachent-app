import 'package:teachent_app/common/consts.dart';
import 'package:teachent_app/database/adapters/hive_adapter.dart';
import 'package:teachent_app/model/db_objects/app_configuration.dart';

/// Methods to maintain AppConfiguration object in database
mixin AppConfigartionMethods {
  /// Return true if app configuration exists
  /// It means that user is logged in
  bool isAppConfigurationAlreadyExists() {
    return HiveDatabaseAdapter.hasConfiguration();
  }

  /// Return app configuration object from local database
  AppConfiguration getAppConfiguration() {
    final configuration = HiveDatabaseAdapter.getConfiguration();
    return AppConfiguration(
        configuration[HiveConsts.userId] ?? '',
        configuration[HiveConsts.themeMode] ?? false,
        configuration[HiveConsts.userMode] ?? true);
  }

  /// Add app configuration object to local database
  /// It means user will be logged in
  void addAppConfiguration(AppConfiguration appConfiguration) {
    final values = {
      HiveConsts.userId: appConfiguration.userId,
      HiveConsts.themeMode: appConfiguration.isDarkMode,
      HiveConsts.userMode: appConfiguration.isTeacher
    };
    HiveDatabaseAdapter.putConfiguration(values);
  }

  /// Remove app confiugration from local database
  /// It means user will be logged out
  void removeAppConfiguration() {
    HiveDatabaseAdapter.removeConfiguration();
  }
}
