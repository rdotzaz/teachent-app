import 'package:teachent_app/common/consts.dart' show DatabaseObjectName;
import 'package:teachent_app/model/db_objects/db_object.dart';

class User extends DatabaseObject {
  final KeyId userId;
  final String login;
  final String password;

  User(this.userId, this.login, this.password);

  factory User.fromMap(String key, Map<String, dynamic> map) {
    return User(key, map['login'] ?? '', map['password'] ?? '');
  }

  @override
  String get collectionName => DatabaseObjectName.users;

  @override
  KeyId get key => userId;

  @override
  Map<String, dynamic> toMap() {
    final map = <String, String>{};

    map.addAll({'login': login});
    map.addAll({'password': password});

    return map;
  }
}
