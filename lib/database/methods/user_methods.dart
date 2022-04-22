import 'package:teachent_app/database/adapters/firebase_adapter.dart';

import '../../common/consts.dart';
import '../../common/enums.dart';
import '../../model/db_objects/db_object.dart';
import '../../model/db_objects/user.dart';

mixin UserDatabaseMethods {
  /// Method returns user when login and password are correct
  /// Otherwise returns null
  Future<LoginResult> checkLoginAndPassword(String login, String password) async {
    final userValues =
        await FirebaseRealTimeDatabaseAdapter.findUserByLoginAndCheckPassword(
            login, password);
    if (userValues.isEmpty) {
      return LoginResult(status: LoginStatus.logicError);
    }

    if (userValues.containsKey('error')) {
      return userValues['error'] == 'login' ?
          LoginResult(status: LoginStatus.loginNotFound) :
          LoginResult(status: LoginStatus.invalidPassword);
    }

    return LoginResult(status: LoginStatus.success, user: User(login, userValues['isDarkMode'] ?? false,
        userValues['isTeacher'] ?? true, password));
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
    return User.fromMap(userId, userValues as Map<String, dynamic>);
  }

  void update(KeyId userId) {}

  void deleteUser(KeyId userId) {}
}
