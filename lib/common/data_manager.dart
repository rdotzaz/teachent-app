class DataManagerCreator {
  static DataManager? _dataManager;

  static DataManager create() {
    if (_dataManager == null) {
      var database = 'database';
      var user = 'user';
      var settings = 'settings';
      _dataManager = DataManager(database, user, settings);
    }
    return _dataManager!;
  }
}

class DataManager {
  final Object database;
  final Object user;
  final Object settings;

  DataManager(this.database, this.user, this.settings);
}
