import 'package:teachent_app/database/database.dart';

import '../../common/consts.dart';
import '../../common/enums.dart';
import '../../model/db_objects/db_object.dart';
import '../../model/db_objects/user.dart';

/// Methods to manage User object in database
mixin UserDatabaseMethods on IDatabase {
  /// Method returns user when login and password are correct
  /// Otherwise returns null
  Future<LoginResult> checkLoginAndPassword(
      String login, String password) async {
    final userValues =
        await firebaseAdapter.findUserByLoginAndCheckPassword(
            login, password);
    if (userValues.isEmpty) {
      return LoginResult(status: LoginStatus.logicError);
    }

    if (userValues.containsKey('error')) {
      return userValues['error'] == 'login'
          ? LoginResult(status: LoginStatus.loginNotFound)
          : LoginResult(status: LoginStatus.invalidPassword);
    }

    return LoginResult(
        status: LoginStatus.success,
        user: User(login, userValues['isDarkMode'] ?? false,
            userValues['isTeacher'] ?? true, password));
  }

  Future<void> addUser(User user) async {
    await firebaseAdapter.addDatabaseObject(
        DatabaseObjectName.users, user.key, user.toMap());
  }

  Future<User?> getUser(KeyId userId) async {
    final userValues = await firebaseAdapter.getObject(
        DatabaseObjectName.users, userId);

    if (userValues.isEmpty) {
      return null;
    }
    return User.fromMap(userId, userValues as Map<String, dynamic>);
  }
}
