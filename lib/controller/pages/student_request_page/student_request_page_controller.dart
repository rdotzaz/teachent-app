import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:teachent_app/common/date.dart';
import 'package:teachent_app/common/enums.dart';
import 'package:teachent_app/common/enum_functions.dart';
import 'package:teachent_app/controller/controller.dart';
import 'package:teachent_app/controller/managers/request_manager.dart';
import 'package:teachent_app/controller/pages/student_request_page/bloc/request_topic_bloc.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';
import 'package:teachent_app/model/db_objects/lesson_date.dart';
import 'package:teachent_app/model/db_objects/request.dart';
import 'package:teachent_app/model/db_objects/teacher.dart';
import 'package:teachent_app/model/objects/message.dart';
import 'package:teachent_app/model/objects/tool.dart';
import 'package:teachent_app/model/objects/topic.dart';
import 'package:teachent_app/model/objects/place.dart';
import 'package:teachent_app/view/widgets/status_bottom_sheet.dart';

/// Controller for Student Ruquest Page
class StudentRequestPageController extends BaseRequestPageController {
  KeyId? requestId;
  KeyId? studentId;
  Teacher? teacher;
  Request? request;
  LessonDate? lessonDate;

  DateTime? otherDate;
  int topicIndex = -1;
  bool hasChangesProvided = false;
  final List<MessageRecord> _newMessages = [];

  late RequestTopicBloc requestTopicBloc;

  StudentRequestPageController(
      this.requestId, this.studentId, this.teacher, this.lessonDate) {
    requestTopicBloc = RequestTopicBloc(this);
  }

  @override
  Future<void> init() async {
    if (requestId == null) {
      print('No requestId passed');
    } else {
      final foundRequest = await dataManager.database.getRequest(requestId!);
      if (foundRequest == null) {
        print('ERROR: No request found. Creation mode');
        return;
      }
      request = foundRequest;
    }

    if (teacher == null) {
      await initTeacher();
    }

    if (lessonDate == null) {
      await initLessonDate();
    }
  }

  Future<void> initTeacher() async {
    final foundTeacher =
        await dataManager.database.getTeacher(request?.teacherId ?? '');
    if (foundTeacher == null) {
      print('ERROR: No teacher found');
      return;
    }
    teacher = foundTeacher;

    if (request != null) {
      final pickedTopic = request!.topic;
      topicIndex = topics.indexWhere((topic) => topic.name == pickedTopic.name);
      requestTopicBloc.add(ToggleTopicEvent(topicIndex));
    }
  }

  Future<void> initLessonDate() async {
    final foundDate =
        await dataManager.database.getLessonDate(request?.lessonDateId ?? '');
    if (foundDate == null) {
      print('ERROR: No date found');
      return;
    }
    lessonDate = foundDate;
  }

  String get exactDay {
    if (request == null) {
      return date;
    }
    return requestedDate;
  }

  String get teacherName => teacher?.name ?? '';
  String get date => DateFormatter.getString(lessonDate!.date);
  String get requestedDate => DateFormatter.getString(otherDate);
  String get statusInfo => request?.status.stringValue ?? '';
  String get additionalInfo => request?.dateStatus.stringValue ?? '';
  bool get isCycled => lessonDate?.isCycled ?? false;
  int get price => lessonDate?.price ?? 0;
  List<Tool> get tools => lessonDate?.tools ?? [];
  List<Place> get places => lessonDate?.places ?? [];
  List<Topic> get topics => teacher?.topics ?? [];
  bool get hasTeacherMessage => false;
  bool get canCheckStatus => request != null;

  Future<void> enableDatePicker(BuildContext context) async {
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: otherDate ?? DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2040));

    if (pickedDate == null) {
      return;
    }

    if (otherDate == null) {
      otherDate = pickedDate;
      return;
    }

    if (pickedDate != otherDate) {
      otherDate = pickedDate;
    }
  }

  void saveRequestedDate() {
    hasChangesProvided = true;
  }

  void cancelRequestedDate() {
    hasChangesProvided = false;
    otherDate = null;
  }

  void setTopicIndex(int index) {
    if (topicIndex == index) {
      topicIndex = -1;
    } else {
      topicIndex = index;
    }
  }

  Color getStatusColor() {
    if (request == null) {
      return Colors.transparent;
    }
    if (request!.status == RequestStatus.newReq ||
        request!.status == RequestStatus.waiting) {
      return Colors.blue;
    }
    if (request!.status == RequestStatus.responded) {
      return Colors.cyanAccent;
    }
    if (request!.status == RequestStatus.rejected) {
      return Colors.red;
    }
    if (request!.status == RequestStatus.accepted) {
      return Colors.green;
    }
    return Colors.black;
  }

  String getStatusAdditionalInfo() {
    if (request!.dateStatus == RequestedDateStatus.requested) {
      return 'Request date: ${request!.requestedDate}';
    }
    if (request!.dateStatus == RequestedDateStatus.rejected) {
      return 'Teacher did not accept\nyour request date: ${request!.requestedDate}';
    }
    if (request!.dateStatus == RequestedDateStatus.accepted) {
      return 'Teacher accepted\nyour request date: ${request!.requestedDate}';
    }
    return '';
  }

  @override
  bool get hasAnyMessages {
    if (request == null) {
      return _newMessages.isNotEmpty;
    }
    return request!.teacherMessages.isNotEmpty || request!.studentMessages.isNotEmpty || _newMessages.isNotEmpty;
  }

  @override
  int get messagesCount {
    if (request == null) {
      return _newMessages.length;
    }
    return request!.teacherMessages.length + request!.studentMessages.length + _newMessages.length;
  }

  @override
  List<MessageField> get messages {
    final newMessageFields = _newMessages.map((m) => MessageField(m, false)).toList();
    if (request == null) {
      return newMessageFields;
    }
    final mergedList = request!.teacherMessages.map((m) => MessageField(m, true)).toList() + request!.studentMessages.map((m) => MessageField(m, false)).toList();
    mergedList.sort((m1, m2) => m1.messageRecord.date.compareTo(m2.messageRecord.date));
    return mergedList + newMessageFields;
  }

  @override
  Future<void> sendMessageAndRefresh(Function refresh) async {
    _newMessages.add(MessageRecord(textController.text, DateTime.now()));
    if (request != null) {
      await RequestManager.sendStudentMessage(dataManager, request!, textController.text);
    }
    textController.clear();
    refresh();
  }

  Future<void> sendResponse(BuildContext context) async {
    assert(hasChangesProvided && request != null);

    await RequestManager.sendStudentResponse(dataManager, request!, otherDate!, topics[topicIndex]);

    await showSuccessMessageAsync(context, 'Request has been updated');
    Navigator.of(context).pop();
  }

  Future<void> sendRequest(BuildContext context) async {
    if (topicIndex == -1) {
      showErrorMessage(context, 'Topic must be selected');
      return;
    }

    request = Request.noKey(
        lessonDate?.lessonDateId ?? '',
        teacher?.userId ?? '',
        studentId ?? '',
        RequestStatus.waiting,
        topics[topicIndex],
        DateFormatter.parse(date),
        otherDate == null
            ? RequestedDateStatus.none
            : RequestedDateStatus.requested,
        DateFormatter.tryParse(requestedDate),
        [],
        _newMessages);

    await RequestManager.sendNew(dataManager, request!, teacher, studentId);

    await showSuccessMessageAsync(context, 'Request has successfully sent');
    Navigator.of(context).pop();
  }
}
