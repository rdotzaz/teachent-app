import 'package:teachent_app/database/database.dart';

class DataManagerCreator {
  static DataManager? _dataManager;

  static DataManager create() {
    if (_dataManager == null) {
      var database = MainDatabase(DBMode.testing);
      var user = 'user';
      var settings = 'settings';
      _dataManager = DataManager(database, user, settings);
    }
    return _dataManager!;
  }
}

class DataManager {
  final MainDatabase database;
  final Object user;
  final Object settings;

  DataManager(this.database, this.user, this.settings);
}
