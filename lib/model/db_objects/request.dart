import 'package:teachent_app/common/consts.dart' show DatabaseObjectName;
import 'package:teachent_app/model/db_objects/db_object.dart';

class Request extends DatabaseObject {
  final KeyId requestId;
  final KeyId lessonDateId;
  final KeyId studentId;
  final int status;

  Request(this.requestId, this.lessonDateId, this.studentId, this.status);

  @override
  String get collectionName => DatabaseObjectName.requests;

  @override
  String get key => requestId;

  @override
  Map<String, dynamic> toMap() {
    final map = <String, String>{};
    return map;
  }
}
