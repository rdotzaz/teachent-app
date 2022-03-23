import 'dart:convert';

typedef KeyId = String;

abstract class DatabaseObject {
  String get collectionName;
  KeyId get key;

  Map<String, dynamic> toMap();
  String toJson() => json.encode(toMap());

  static KeyId emptyKey = '';
}
