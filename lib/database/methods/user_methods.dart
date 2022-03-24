import 'package:teachent_app/database/adapters/firebase_adapter.dart';

import '../../model/db_objects/db_object.dart';
import '../../model/db_objects/user.dart';

mixin UserDatabaseMethods {
  /// Method returns userId when login and password are correct
  /// Otherwise returns DatabseConsts.emptyKey
  Future<KeyId> checkLoginAndPassword(String login, String password) async {
    var keyId =
        await FirebaseRealTimeDatabaseAdapter.findUserByLoginAndCheckPassword(
            login, password);
    return keyId;
  }

  void addUser(User user) {
    FirebaseRealTimeDatabaseAdapter.addUser(user.key, user.toMap());
  }

  void update(KeyId userId) {}

  void deleteUser(KeyId userId) {}
}
