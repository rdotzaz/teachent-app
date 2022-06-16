import 'package:teachent_app/common/consts.dart';
import 'package:teachent_app/database/adapters/hive_adapter.dart';
import 'package:teachent_app/model/db_objects/app_configuration.dart';

/// Methods to maintain AppConfiguration object in database
mixin AppConfigartionMethods {
  bool isAppConfigurationAlreadyExists() {
    return HiveDatabaseAdapter.hasConfiguration();
  }

  AppConfiguration getAppConfiguration() {
    final configuration = HiveDatabaseAdapter.getConfiguration();
    return AppConfiguration(
        configuration[HiveConsts.userId] ?? '',
        configuration[HiveConsts.themeMode] ?? false,
        configuration[HiveConsts.userMode] ?? true);
  }

  void addAppConfiguration(AppConfiguration appConfiguration) {
    final values = {
      HiveConsts.userId: appConfiguration.userId,
      HiveConsts.themeMode: appConfiguration.isDarkMode,
      HiveConsts.userMode: appConfiguration.isTeacher
    };
    HiveDatabaseAdapter.putConfiguration(values);
  }

  void removeAppConfiguration() {
    HiveDatabaseAdapter.removeConfiguration();
  }
}
