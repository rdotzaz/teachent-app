import 'package:teachent_app/common/consts.dart'
    show DatabaseConsts, DatabaseObjectName;
import 'package:teachent_app/model/db_objects/db_object.dart';

class User extends DatabaseObject {
  final KeyId userId;
  final String login;
  final String password;

  User(this.userId, this.login, this.password);

  User.noKey(this.login, this.password) : userId = DatabaseConsts.emptyKey;

  factory User.fromMap(String key, Map<String, dynamic> map) {
    return User(key, map['login'] ?? '', map['password'] ?? '');
  }

  @override
  String get collectionName => DatabaseObjectName.users;

  @override
  KeyId get key => userId;

  @override
  Map<String, dynamic> toMap() {
    return {'login': login, 'password': password};
  }
}
