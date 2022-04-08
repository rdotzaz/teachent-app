import 'package:teachent_app/database/adapters/hive_adapter.dart';
import 'package:teachent_app/model/db_objects/app_configuration.dart';

mixin AppConfigartionMethods {
  bool isAppConfigurationAlreadyExists() {
    return HiveDatabaseAdapter.hasConfiguration();
  }

  AppConfiguration getAppConfiguration() {
    var configuration = HiveDatabaseAdapter.getConfiguration();
    return AppConfiguration(configuration['userId'] ?? '',
        configuration['themeMode'] ?? false, configuration['userMode'] ?? true);
  }

  void addAppConfiguration(AppConfiguration appConfiguration) {
    var values = {
      'userId': appConfiguration.userId,
      'themeMode': appConfiguration.isDarkMode,
      'userMode': appConfiguration.isTeacher
    };
    HiveDatabaseAdapter.putConfiguration(values);
  }
}
