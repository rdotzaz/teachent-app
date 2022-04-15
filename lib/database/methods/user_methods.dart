import 'package:teachent_app/database/adapters/firebase_adapter.dart';

import '../../common/consts.dart';
import '../../model/db_objects/db_object.dart';
import '../../model/db_objects/user.dart';

mixin UserDatabaseMethods {
  /// Method returns user when login and password are correct
  /// Otherwise returns null
  Future<User?> checkLoginAndPassword(String login, String password) async {
    final userValues =
        await FirebaseRealTimeDatabaseAdapter.findUserByLoginAndCheckPassword(
            login, password);
    if (userValues.isEmpty) {
      return null;
    }

    return User(login, userValues['isDarkMode'] ?? false,
        userValues['isTeacher'] ?? true, password);
  }

  Future<void> addUser(User user) async {
    print('User');
    var wasAdded = await FirebaseRealTimeDatabaseAdapter.addDatabaseObject(
        DatabaseObjectName.users, user.key, user.toMap());
    return;
  }

  Future<User?> getUser(KeyId userId) async {
    final userValues = await FirebaseRealTimeDatabaseAdapter.getObject(
      DatabaseObjectName.users, userId);
    
    if (userValues.isEmpty) {
      return null;
    }

    userValues['login'] = userId;
    return User.fromMap(userValues as Map<String, dynamic>);
  }

  void update(KeyId userId) {}

  void deleteUser(KeyId userId) {}
}
