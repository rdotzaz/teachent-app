import 'package:intl/intl.dart';
import 'package:teachent_app/common/consts.dart';
import 'package:teachent_app/database/adapters/firebase_adapter.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';
import 'package:teachent_app/model/objects/message.dart';

/// Methods to maintain Message object in database
mixin MessageDatabaseMethods {
  /// Add [message] teacher to request with [requestId]
  Future<void> addTeacherMessage(KeyId requestId, MessageRecord message) async {
    final date = DateFormat('yyyy-MM-dd hh:mm:ss').format(message.date);
    await FirebaseRealTimeDatabaseAdapter.updateField(
        DatabaseObjectName.requrests, requestId, 'teacherMessages', {message.message: date});
  }

  /// Add [message] student to request with [requestId]
  Future<void> addStudentMessage(KeyId requestId, MessageRecord message) async {
    final date = DateFormat('yyyy-MM-dd hh:mm:ss').format(message.date);
    await FirebaseRealTimeDatabaseAdapter.updateField(
        DatabaseObjectName.requrests, requestId, 'studentMessages', {message.message: date});
  }
}
