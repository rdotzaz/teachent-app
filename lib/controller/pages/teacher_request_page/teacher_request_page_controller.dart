import 'package:flutter/material.dart';
import 'package:teachent_app/common/date.dart';
import 'package:teachent_app/common/enums.dart';
import 'package:teachent_app/common/enum_functions.dart';
import 'package:teachent_app/controller/controller.dart';
import 'package:teachent_app/controller/managers/lesson_manager.dart';
import 'package:teachent_app/controller/managers/request_manager.dart';
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
  /// Teacher id which is assigned to [request]
  KeyId? teacherId;

  /// Student object which contains request id from [request]
  Student? student;

  /// Lesson date (cooperation) object based on lesson date id from [request]
  LessonDate? lessonDate;

  /// Request object
  Request request;

  /// Status of new requested date by student
  /// If student did not request new date, then default value is [RequestedDateStatus.none]
  RequestedDateStatus newDateStatus = RequestedDateStatus.none;
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

  /// Method retreives student object based on student id from [request]
  Future<void> initStudent() async {
    final foundStudent =
        await dataManager.database.getStudent(request.studentId);
    if (foundStudent == null) {
      throw Exception('ERROR: No student found');
    }
    student = foundStudent;
  }

  /// Method retreives lesson date (cooperation) object based on lesson date id from [request]
  Future<void> initLessonDate() async {
    final foundDate =
        await dataManager.database.getLessonDate(request.lessonDateId);
    if (foundDate == null) {
      throw Exception('ERROR: No date found');
    }
    lessonDate = foundDate;
  }

  /// Student name
  String get studentName => student?.name ?? '';

  /// Get date from lesson date (cooperation) object
  /// It is start date of cooperation
  /// If new date requested by student was accepted, then requested date os returned
  String get date => request.dateStatus == RequestedDateStatus.accepted
      ? DateFormatter.getString(request.requestedDate)
      : DateFormatter.getString(lessonDate?.date);

  /// Get string representation of requested date
  String get requestedDate =>
      DateFormatter.getString(request.requestedDate);

  /// Return true if cooperation is cycled
  bool get isCycled => lessonDate?.isCycled ?? false;

  /// Get price provided by teacher
  int get price => lessonDate?.price ?? 0;

  /// Get list of tools provided by teacher
  List<Tool> get tools => lessonDate?.tools ?? [];

  /// Get list of places provided by teacher
  List<Place> get places => lessonDate?.places ?? [];

  /// Get topic selected by student
  Topic get topic => request.topic;

  /// Return true if student requested new date
  bool get wasOtherDateRequested =>
      request.dateStatus == RequestedDateStatus.requested;

  /// Get string representation of coopearion status
  String get statusInfo => request.status.stringValue;

  /// Get string representation of new requested date status
  String get additionalInfo => request.dateStatus.stringValue;

  /// Return true if request was not accepted neither rejected
  bool get isEnabled =>
      request.status != RequestStatus.accepted &&
      request.status != RequestStatus.rejected;

  @override
  bool get hasAnyMessages =>
      request.teacherMessages.isNotEmpty ||
      request.studentMessages.isNotEmpty ||
      _newMessages.isNotEmpty;

  @override
  int get messagesCount =>
      request.teacherMessages.length +
      request.studentMessages.length +
      _newMessages.length;

  @override
  List<MessageField> get messages {
    final newMessages =
        _newMessages.map((m) => MessageField(m, false)).toList();
    final mergedList =
        request.teacherMessages.map((m) => MessageField(m, false)).toList() +
            request.studentMessages.map((m) => MessageField(m, true)).toList();
    mergedList.sort(
        (m1, m2) => m1.messageRecord.date.compareTo(m2.messageRecord.date));
    return mergedList + newMessages;
  }

  /// Get color of status bar on the page
  Color getStatusColor() {
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

  /// Reject date proposed by student
  void rejectNewDate() {
    print(isEnabled);
    if (!isEnabled) {
      return;
    }
    newDateStatus = RequestedDateStatus.rejected;
    print(newDateStatus);
  }

  /// Restore date proposed by student
  void restoreNewDate() {
    print(isEnabled);
    if (!isEnabled) {
      return;
    }
    newDateStatus = RequestedDateStatus.accepted;
  }

  @override
  Future<void> sendMessageAndRefresh(
      BuildContext context, Function refresh) async {
    if (!await dataManager.database
        .isLessonDateFree(lessonDate?.lessonDateId ?? '') && lessonDate?.teacherId != teacherId) {
      showErrorMessage(context, 'Lesson date was reserved by someone else');
      return;
    }

    _newMessages.add(MessageRecord(textController.text, DateTime.now()));
    await RequestManager.sendTeacherMessage(
        dataManager, request, textController.text);
    textController.clear();
    refresh();
  }

  Future<void> sendResponse(BuildContext context) async {
    if (!isEnabled) {
      return;
    }
    if (!await dataManager.database
        .isLessonDateFree(lessonDate?.lessonDateId ?? '')) {
      showErrorMessage(context, 'Lesson date was reserved by someone else');
      return;
    }

    await RequestManager.sendTeacherResponse(
        dataManager, request, newDateStatus);
    Navigator.of(context).pop();
  }

  /// Method triggers RequestManager and LessonManager to accept request sent by student
  Future<void> acceptRequest(BuildContext context) async {
    if (!isEnabled) {
      return;
    }
    if (newDateStatus == RequestedDateStatus.requested) {
      showErrorMessage(context, 'You need to accept or reject new date first');
      return;
    }
    if (!await dataManager.database
        .isLessonDateFree(lessonDate?.lessonDateId ?? '')) {
      showErrorMessage(context, 'Lesson date was reserved by someone else');
      return;
    }

    await RequestManager.acceptRequest(
        dataManager, request, student, lessonDate);
    await showSuccessMessageAsync(context, 'Request has been accepted');
    Navigator.of(context).pop();
  }

  /// Method triggers RequestManager to reject request sent by student
  Future<void> rejectRequest(BuildContext context) async {
    if (!isEnabled) {
      return;
    }
    if (!await dataManager.database
        .isLessonDateFree(lessonDate?.lessonDateId ?? '')) {
      showErrorMessage(context, 'Lesson date was reserved by someone else');
      return;
    }

    await RequestManager.rejectRequest(dataManager, request);
    await showSuccessMessageAsync(context, 'Request has been rejected');
    Navigator.of(context).pop();
  }
}
