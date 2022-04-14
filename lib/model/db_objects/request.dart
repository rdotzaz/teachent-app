import 'package:teachent_app/common/consts.dart'
    show DatabaseConsts, DatabaseObjectName;
import 'package:teachent_app/model/db_objects/db_object.dart';

/// Object representation of request from student to teacher
/// Contains current status of request
class Request extends DatabaseObject {
  final KeyId requestId;
  final KeyId lessonDateId;
  final KeyId studentId;
  final int status;

  Request(this.requestId, this.lessonDateId, this.studentId, this.status);

  Request.noKey(this.lessonDateId, this.studentId, this.status)
      : requestId = DatabaseConsts.emptyKey;

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
