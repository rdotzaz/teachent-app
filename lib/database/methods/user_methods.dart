import 'package:teachent_app/database/adapters/firebase_adapter.dart';

import '../../common/consts.dart';
import '../../model/db_objects/db_object.dart';
import '../../model/db_objects/user.dart';

mixin UserDatabaseMethods {
  /// Method returns userId when login and password are correct
  /// Otherwise returns DatabseConsts.emptyKey
  Future<KeyId> checkLoginAndPassword(String login, String password) async {
    return await FirebaseRealTimeDatabaseAdapter
        .findUserByLoginAndCheckPassword(login, password);
  }

  Future<void> addUser(User user) async {
    print('User');
    var wasAdded = await FirebaseRealTimeDatabaseAdapter.addDatabaseObject(
      DatabaseObjectName.users, user.key, user.toMap());
    return;
  }

  void update(KeyId userId) {}

  void deleteUser(KeyId userId) {}
}
