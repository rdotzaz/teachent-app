import 'package:teachent_app/common/consts.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';

class User extends DatabaseObject {
  final KeyId login;
  final bool isDarkMode;
  final bool isTeacher;
  final String password;

  User(this.login, this.isDarkMode, this.isTeacher, this.password);
  User.noMode(this.login, this.password)
      : isDarkMode = false,
        isTeacher = false;

  User.fromMap(this.login, Map<String, dynamic> values)
      : isDarkMode = values['isDarkMode'] ?? false,
        isTeacher = values['isTeacher'] ?? false,
        password = values['password'] ?? '';

  @override
  String get collectionName => DatabaseObjectName.users;

  @override
  KeyId get key => login;

  @override
  Map<String, dynamic> toMap() {
    return {
      'isDarkMode': isDarkMode,
      'isTeacher': isTeacher,
      'password': password
    };
  }
}
