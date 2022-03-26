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

  factory User.fromMap(Map<String, dynamic> map) {
    return User(map['login'] ?? '', map['isDarkMode'] ?? false,
        map['isTeacher'] ?? false, map['password'] ?? '');
  }

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
