import 'dart:convert';

typedef KeyId = String;

/// Abstract class of database object
abstract class DatabaseObject {
  String get collectionName;
  KeyId get key;

  Map<String, dynamic> toMap();
  String toJson() => json.encode(toMap());

  static KeyId emptyKey = '';

  static Map<String, dynamic> getMapFromField(
      Map<dynamic, dynamic> values, String field) {
    if (values[field] == null) {
      return {};
    }
    return {
      for (var entry in (values[field] as Map<dynamic, dynamic>).entries)
        (entry.key as String): entry.value
    };
  }
}
