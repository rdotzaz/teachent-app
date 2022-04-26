import 'package:teachent_app/common/consts.dart'
    show DatabaseConsts, DatabaseObjectName;
import 'package:teachent_app/common/enums.dart';
import 'package:teachent_app/common/enum_functions.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';
import 'package:teachent_app/model/objects/message.dart';
import 'package:teachent_app/model/objects/topic.dart';

class Request extends DatabaseObject {
  final KeyId requestId;
  final KeyId lessonDateId;
  final KeyId teacherId;
  final KeyId studentId;
  final RequestStatus status;
  final Topic topic;
  final RequestedDateStatus dateStatus;
  final String requestedDate;
  final List<MessageRecord> teacherMessages;
  final List<MessageRecord> studentMessages;

  Request(
      this.requestId,
      this.lessonDateId,
      this.teacherId,
      this.studentId,
      this.status,
      this.topic,
      this.dateStatus,
      this.requestedDate,
      this.teacherMessages,
      this.studentMessages);

  Request.noKey(
      this.lessonDateId,
      this.teacherId,
      this.studentId,
      this.status,
      this.topic,
      this.dateStatus,
      this.requestedDate,
      this.teacherMessages,
      this.studentMessages)
      : requestId = DatabaseConsts.emptyKey;

  Request.fromMap(this.requestId, Map<dynamic, dynamic> values)
      : lessonDateId = values['lessonDateId'] ?? '',
        teacherId = values['teacherId'] ?? '',
        studentId = values['studentId'] ?? '',
        status = getRequestStatusByValue(values['status'] ?? -1),
        topic = Topic(values['topic'].keys.firstWhere((_) => true) ?? '', true),
        dateStatus = getRequestedDateStatusByValue(values['dateStatus'] ?? -1),
        requestedDate = values['requestedDate'] ?? '',
        teacherMessages =
            DatabaseObject.getMapFromField(values, 'teacherMessages')
                .entries
                .map((m) => MessageRecord(m.key, m.value))
                .toList(),
        studentMessages =
            DatabaseObject.getMapFromField(values, 'studentMessages')
                .entries
                .map((m) => MessageRecord(m.key, m.value))
                .toList();

  @override
  String get collectionName => DatabaseObjectName.requests;

  @override
  String get key => requestId;

  @override
  Map<String, dynamic> toMap() {
    return {
      'lessonDateId': lessonDateId,
      'teacherId': teacherId,
      'studentId': studentId,
      'status': status.value,
      'topic': {topic.name: true},
      'requestedDate': requestedDate,
      'teacherMessages': {
        for (final teacherMessage in teacherMessages)
          teacherMessage.message: teacherMessage.date
      },
      'studentMessages': {
        for (final studentMessage in studentMessages)
          studentMessage.message: studentMessage.date
      },
    };
  }
}
