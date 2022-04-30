import 'package:teachent_app/database/database.dart';
import 'package:teachent_app/model/db_objects/app_configuration.dart';

class DataManagerCreator {
  static DataManager? _dataManager;

  static DataManager create() {
    if (_dataManager == null) {
      var database = MainDatabase();
      _dataManager = DataManager(database);
    }
    return _dataManager!;
  }
}

class DataManager {
  final MainDatabase _database;
  AppConfiguration? _appConfiguration;

  DataManager(this._database);

  MainDatabase get database => _database;

  AppConfiguration? get appConfiguration => _appConfiguration;

  set appConfiguration(configuration) => _appConfiguration = configuration;
}
