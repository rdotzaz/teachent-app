import 'package:teachent_app/common/consts.dart';
import 'package:teachent_app/common/date.dart';
import 'package:teachent_app/database/database.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';
import 'package:teachent_app/model/objects/message.dart';

/// Methods to maintain Message object in database
mixin MessageDatabaseMethods on IDatabase {
  /// Add [message] teacher to request with [requestId]
  Future<void> addTeacherMessage(KeyId requestId, MessageRecord message) async {
    await firebaseAdapter.updateField(
        DatabaseObjectName.requests,
        requestId,
        'teacherMessages',
        {message.message: DateFormatter.getString(message.date)});
  }

  /// Add [message] student to request with [requestId]
  Future<void> addStudentMessage(KeyId requestId, MessageRecord message) async {
    await firebaseAdapter.updateField(
        DatabaseObjectName.requests,
        requestId,
        'studentMessages',
        {message.message: DateFormatter.getString(message.date)});
  }
}
