import 'package:teachent_app/common/firebase_enums.dart';
import 'package:teachent_app/database/adapters/firebase_adapter.dart';

import '../../common/consts.dart';
import '../../common/enums.dart';
import '../../model/db_objects/db_object.dart';
import '../../model/db_objects/user.dart';

/// Methods to manage User object in database
mixin UserDatabaseMethods {
  /// Method returns user when login and password are correct
  /// Otherwise result with error status
  Future<LoginResult> checkLoginAndPassword(
      String login, String password) async {
    final response =
        await FirebaseRealTimeDatabaseAdapter.findUserByLoginAndCheckPassword(
            login, password);
    if (response.loginResult?.status == LoginStatus.logicError) {
      return LoginResult(status: LoginStatus.logicError);
    }

    if (response.status == FirebaseResponseStatus.failure) {
      return response.loginResult ??
          LoginResult(status: LoginStatus.logicError);
    }

    return LoginResult(
        status: LoginStatus.success,
        user: User(login, response.data['isDarkMode'] ?? false,
            response.data['isTeacher'] ?? true, password));
  }

  /// Add [user] to database
  Future<void> addUser(User user) async {
    await FirebaseRealTimeDatabaseAdapter.addDatabaseObject(
        DatabaseObjectName.users, user.key, user.toMap());
  }

  /// Get user with [userId] from database
  Future<User?> getUser(KeyId userId) async {
    final response = await FirebaseRealTimeDatabaseAdapter.getObject(
        DatabaseObjectName.users, userId);

    if (response.status == FirebaseResponseStatus.failure) {
      return null;
    }
    return User.fromMap(userId, response.data as Map<String, dynamic>);
  }
}
