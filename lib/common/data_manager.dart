import 'dart:developer' as dev;

import 'package:teachent_app/database/database.dart';
import 'package:teachent_app/model/db_objects/app_configuration.dart';

/// DataManager creator class
/// Use in BaseController class
class DataManagerCreator {
  static DataManager? _dataManager;

  /// Creates new instances or returns existing one
  static DataManager create() {
    if (_dataManager == null) {
      var database = MainDatabase();
      _dataManager = DataManager(database);
    }
    dev.log('[DataManagerCreator] Create DataManager object');
    return _dataManager!;
  }
}

/// Global object with most important parameters/objects
/// Currently contains
/// - database reference
/// - app configuration object - Object with local settings
class DataManager {
  final MainDatabase _database;
  AppConfiguration? _appConfiguration;

  DataManager(this._database);

  MainDatabase get database => _database;

  AppConfiguration? get appConfiguration => _appConfiguration;

  set appConfiguration(configuration) => _appConfiguration = configuration;
}
