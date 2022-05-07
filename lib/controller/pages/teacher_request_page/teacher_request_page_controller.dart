import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:teachent_app/common/date.dart';
import 'package:teachent_app/common/enums.dart';
import 'package:teachent_app/common/enum_functions.dart';
import 'package:teachent_app/controller/controller.dart';
import 'package:teachent_app/controller/managers/lesson_manager.dart';
import 'package:teachent_app/controller/managers/request_manager.dart';
import 'package:teachent_app/controller/pages/student_request_page/bloc/request_topic_bloc.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';
import 'package:teachent_app/model/db_objects/lesson_date.dart';
import 'package:teachent_app/model/db_objects/request.dart';
import 'package:teachent_app/model/db_objects/student.dart';
import 'package:teachent_app/model/objects/tool.dart';
import 'package:teachent_app/model/objects/topic.dart';
import 'package:teachent_app/model/objects/place.dart';
import 'package:teachent_app/model/objects/message.dart';
import 'package:teachent_app/view/widgets/status_bottom_sheet.dart';

/// Controller for Teacher Request Page
class TeacherRequestPageController extends BaseRequestPageController {
  KeyId? teacherId;
  Student? student;
  LessonDate? lessonDate;

  Request request;

  bool isNewDateAccepted = true;
  final List<MessageRecord> _newMessages = [];

  TeacherRequestPageController(
      this.request, this.teacherId, this.student, this.lessonDate);

  @override
  Future<void> init() async {
    if (student == null) {
      await initStudent();
    }

    if (lessonDate == null) {
      await initLessonDate();
    }
  }

  Future<void> initStudent() async {
    final foundStudent =
        await dataManager.database.getStudent(request.studentId);
    if (foundStudent == null) {
      print('ERROR: No student found');
      return;
    }
    student = foundStudent;
  }

  Future<void> initLessonDate() async {
    final foundDate =
        await dataManager.database.getLessonDate(request.lessonDateId);
    if (foundDate == null) {
      print('ERROR: No date found');
      return;
    }
    lessonDate = foundDate;
  }

  String get studentName => student?.name ?? '';
  String get date => DateFormatter.getString(lessonDate?.date);
  String get requestedDate => DateFormatter.onlyDateString(request.requestedDate);
  bool get isCycled => lessonDate?.isCycled ?? false;
  int get price => lessonDate?.price ?? 0;
  List<Tool> get tools => lessonDate?.tools ?? [];
  List<Place> get places => lessonDate?.places ?? [];
  Topic get topic => request.topic;
  bool get wasOtherDateRequested =>
      request.dateStatus == RequestedDateStatus.requested;
  String get statusInfo => request.status.stringValue;
  String get additionalInfo => request.dateStatus.stringValue;

  @override
  bool get hasAnyMessages => request.teacherMessages.isNotEmpty || request.studentMessages.isNotEmpty || _newMessages.isNotEmpty;

  @override
  int get messagesCount => request.teacherMessages.length + request.studentMessages.length + _newMessages.length;

  @override
  List<MessageField> get messages {
    final newMessages = _newMessages.map((m) => MessageField(m, false)).toList();
    final mergedList = request.teacherMessages.map((m) => MessageField(m, false)).toList() + request.studentMessages.map((m) => MessageField(m, true)).toList();
    mergedList.sort((m1, m2) => m1.messageRecord.date.compareTo(m2.messageRecord.date));
    return mergedList + newMessages;
  }

  Color getStatusColor() {
    if (request == null) {
      return Colors.white;
    }
    if (request.status == RequestStatus.newReq ||
        request.status == RequestStatus.waiting) {
      return Colors.blue;
    }
    if (request.status == RequestStatus.responded) {
      return Colors.cyanAccent;
    }
    if (request.status == RequestStatus.rejected) {
      return Colors.red;
    }
    if (request.status == RequestStatus.accepted) {
      return Colors.green;
    }
    return Colors.black;
  }

  void rejectNewDate() {
    isNewDateAccepted = false;
  }

  void restoreNewDate() {
    isNewDateAccepted = true;
  }

  @override
  Future<void> sendMessageAndRefresh(Function refresh) async {
    _newMessages.add(MessageRecord(textController.text, DateTime.now()));
    await RequestManager.sendTeacherMessage(dataManager, request, textController.text);
    textController.clear();
    refresh();
  }

  Future<void> sendResponse(BuildContext context) async {
    await RequestManager.sendTeacherResponse(dataManager, request, isNewDateAccepted);
    Navigator.of(context).pop();
  }

  Future<void> acceptRequest(BuildContext context) async {
    await RequestManager.acceptRequest(dataManager, request, student?.userId ?? '', lessonDate);
    await LessonManager.createFirst(dataManager, student?.userId ?? '', lessonDate!);
    await showSuccessMessageAsync(context, 'Request has been accepted');
    Navigator.of(context).pop();
  }

  Future<void> rejectRequest(BuildContext context) async {
    await RequestManager.rejectRequest(dataManager, request);
    await showSuccessMessageAsync(context, 'Request has been rejected');
    Navigator.of(context).pop();
  }
}
