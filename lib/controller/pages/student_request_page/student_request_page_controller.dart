import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachent_app/common/date.dart';
import 'package:teachent_app/common/enums.dart';
import 'package:teachent_app/common/enum_functions.dart';
import 'package:teachent_app/controller/controller.dart';
import 'package:teachent_app/controller/managers/request_manager.dart';
import 'package:teachent_app/controller/pages/student_request_page/bloc/request_topic_bloc.dart';
import 'package:teachent_app/controller/pages/student_request_page/bloc/request_day_bloc.dart';
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
  /// Request Id
  KeyId? requestId;

  /// Student Id which is assigned to [requestId]
  KeyId? studentId;

  /// Teacher object which contains [requestId]
  Teacher? teacher;

  /// Request object with [requestId]
  Request? request;

  /// Lesson date (cooperation) object based on lesson date id from [request]
  LessonDate? lessonDate;

  /// Date selected by user in date picker.
  /// This date can be requested by student to change starting date of cooperation
  DateTime? otherDate;

  /// Time selected by user in time picker
  /// This time can be requested by student to change starting time of cooperation
  TimeOfDay? otherTime;

  /// Index in topic list
  int topicIndex = 0;

  /// Property is true if some changes were provided by student
  /// E.g. saved new requested date
  bool hasChangesProvided = false;
  final List<MessageRecord> _newMessages = [];

  late RequestTopicBloc requestTopicBloc;

  StudentRequestPageController(
      this.requestId, this.studentId, this.teacher, this.lessonDate) {
    requestTopicBloc = RequestTopicBloc(this);
  }

  @override
  Future<void> init() async {
    if (requestId != null) {
      final foundRequest = await dataManager.database.getRequest(requestId!);
      if (foundRequest == null) {
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

  /// Method retreives teacher object based on teacher id from [request]
  Future<void> initTeacher() async {
    final foundTeacher =
        await dataManager.database.getTeacher(request?.teacherId ?? '');
    if (foundTeacher == null) {
      throw Exception('ERROR: No teacher found');
    }
    teacher = foundTeacher;

    if (request != null) {
      final pickedTopic = request!.topic;
      topicIndex = topics.indexWhere((topic) => topic.name == pickedTopic.name);
      requestTopicBloc.add(ToggleTopicEvent(topicIndex));
    }
  }

  /// Method retreives lesson date (cooperation) object based on lesson date id from [request]
  Future<void> initLessonDate() async {
    final foundDate =
        await dataManager.database.getLessonDate(request?.lessonDateId ?? '');
    if (foundDate == null) {
      throw Exception('ERROR: No date found');
    }
    lessonDate = foundDate;
  }

  /// Teacher name
  String get teacherName => teacher?.name ?? '';

  /// Get date from lesson date (cooperation) object
  /// It is start date of cooperation
  /// If date requested by student was accepted, then requested date is returned
  String get infoDate => (request?.dateStatus ?? RequestedDateStatus.none) ==
          RequestedDateStatus.accepted
      ? DateFormatter.getString(request!.requestedDate)
      : DateFormatter.getString(lessonDate!.date);

  /// Get string representation of [date] choosed by teacher
  String get currentDate => DateFormatter.onlyDateString(lessonDate!.date);

  /// Get string representation of time choosed by teacher
  String get currentTime => DateFormatter.onlyTimeString(lessonDate!.date);

  /// Get string representation of [otherDate]
  String get requestedDate =>
      otherDate != null ? DateFormatter.onlyDateString(otherDate) : currentDate;

  /// Get string representation of [otherTime]
  String get requestedTime =>
      otherTime != null ? DateFormatter.timeString(otherTime) : currentTime;

  /// Get string representation of request status
  String get statusInfo => request?.status.stringValue ?? '';

  /// Get string representation of requested date status
  String get additionalInfo => request?.dateStatus.stringValue ?? '';

  /// Returns true if cooperation is cycled
  bool get isCycled => lessonDate?.isCycled ?? false;

  /// Get price given by teacher
  int get price => lessonDate?.price ?? 0;

  /// Get list of available tools in cooperation
  List<Tool> get tools => lessonDate?.tools ?? [];

  /// Get list of available places in cooperation
  List<Place> get places => lessonDate?.places ?? [];

  /// Get list of available topics in cooperation
  List<Topic> get topics => teacher?.topics ?? [];

  /// Return true if there is message from teacher
  bool get hasTeacherMessage => false;

  /// Return true if request status can be checked
  bool get canCheckStatus => request != null;

  /// Return true if request was not accepted neither rejected
  bool get isEnabled =>
      request?.status != RequestStatus.accepted &&
      request?.status != RequestStatus.rejected;

  Future<void> _enableDatePicker(BuildContext context) async {
    if (!isEnabled) {
      return;
    }
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: otherDate ?? lessonDate!.date,
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

  Future<void> _enableTimePicker(BuildContext context) async {
    if (!isEnabled) {
      return;
    }
    final pickedTime = await showTimePicker(
        context: context,
        initialTime: otherTime ??
            TimeOfDay(
                hour: lessonDate!.date.hour, minute: lessonDate!.date.minute),
        builder: (context, child) {
          return MediaQuery(
              data:
                  MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
              child: child!);
        });

    if (pickedTime == null) {
      return;
    }

    if (otherTime == null) {
      otherTime = pickedTime;
      return;
    }

    if (pickedTime != otherTime) {
      otherTime = pickedTime;
    }
  }

  /// Save requested date by student
  void saveRequestedDate() {
    if (!isEnabled) {
      return;
    }
    hasChangesProvided = true;
  }

  /// Remove requested date by student
  void cancelRequestedDate() {
    if (!isEnabled) {
      return;
    }
    hasChangesProvided = false;
    otherDate = null;
    otherTime = null;
  }

  /// Set topic index of [topics] list
  void setTopicIndex(int index) {
    if (!isEnabled) {
      return;
    }
    if (topicIndex == index) {
      topicIndex = 0;
    } else {
      topicIndex = index;
    }
  }

  /// Get color of status bar on the page
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

  /// Get status bar additonal info regarding request
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
    return request!.teacherMessages.isNotEmpty ||
        request!.studentMessages.isNotEmpty ||
        _newMessages.isNotEmpty;
  }

  @override
  int get messagesCount {
    if (request == null) {
      return _newMessages.length;
    }
    return request!.teacherMessages.length +
        request!.studentMessages.length +
        _newMessages.length;
  }

  @override
  List<MessageField> get messages {
    final newMessageFields =
        _newMessages.map((m) => MessageField(m, false)).toList();
    if (request == null) {
      return newMessageFields;
    }
    final mergedList = request!.teacherMessages
            .map((m) => MessageField(m, true))
            .toList() +
        request!.studentMessages.map((m) => MessageField(m, false)).toList();
    mergedList.sort(
        (m1, m2) => m1.messageRecord.date.compareTo(m2.messageRecord.date));
    return mergedList + newMessageFields;
  }

  @override
  Future<void> sendMessageAndRefresh(
      BuildContext context, Function refresh) async {
    if (!await dataManager.database
            .isLessonDateFree(lessonDate?.lessonDateId ?? '') &&
        lessonDate?.studentId != studentId) {
      showErrorMessage(context, 'Lesson date was reserved by someone else');
      return;
    }

    _newMessages.add(MessageRecord(textController.text, DateTime.now()));
    if (request != null) {
      await RequestManager.sendStudentMessage(
          dataManager, request!, textController.text);
    }
    textController.clear();
    refresh();
  }

  /// Show request day field to request new date by student
  void toggleRequestDatePicker(BuildContext context) async {
    if (!isEnabled) {
      return;
    }
    await _enableDatePicker(context);
    context.read<RequestDayBloc>().add(ToggleRequestDayField());
  }

  /// Show request day field to request new time by student
  void toggleRequestTimePicker(BuildContext context) async {
    if (!isEnabled) {
      return;
    }
    await _enableTimePicker(context);
    context.read<RequestDayBloc>().add(ToggleRequestDayField());
  }

  /// Method triggers [RequestManager] to send response with new requested date by student
  /// Shows bottom sheet with success or error message
  Future<void> sendResponse(BuildContext context) async {
    if (!isEnabled) {
      return;
    }
    if (!await dataManager.database
        .isLessonDateFree(lessonDate?.lessonDateId ?? '')) {
      showErrorMessage(context, 'Lesson date was reserved by someone else');
      return;
    }
    assert(hasChangesProvided && request != null && otherDate != null,
        otherTime != null);

    await RequestManager.sendStudentResponse(
        dataManager, request!, otherDate!, otherTime!, topics[topicIndex]);

    await showSuccessMessageAsync(context, 'Request has been updated');
    Navigator.of(context).pop();
  }

  /// Method triggers [RequestManager] to send new request to teacher
  Future<void> sendRequest(BuildContext context) async {
    if (!isEnabled) {
      return;
    }
    if (topicIndex == -1) {
      showErrorMessage(context, 'Topic must be selected');
      return;
    }
    if (!await dataManager.database
        .isLessonDateFree(lessonDate?.lessonDateId ?? '')) {
      showErrorMessage(context, 'Lesson date was reserved by someone else');
      return;
    }

    request = Request.noKey(
        lessonDate?.lessonDateId ?? '',
        teacher?.userId ?? '',
        studentId ?? '',
        RequestStatus.waiting,
        topics[topicIndex],
        lessonDate!.date,
        otherDate == null
            ? RequestedDateStatus.none
            : RequestedDateStatus.requested,
        _getRequestedDate(),
        [],
        _newMessages);

    await RequestManager.sendNew(dataManager, request!, teacher, studentId);

    await showSuccessMessageAsync(context, 'Request has successfully sent');
    Navigator.of(context).pop();
  }

  DateTime? _getRequestedDate() {
    if (otherDate == null && otherTime == null) {
      return null;
    }
    final newWholeDate = otherDate ?? lessonDate!.date;
    final newOnlyDate =
        DateTime(newWholeDate.year, newWholeDate.month, newWholeDate.day);
    final oldTime =
        TimeOfDay(hour: newWholeDate.hour, minute: newWholeDate.minute);
    return DateFormatter.addTime(newOnlyDate, otherTime ?? oldTime);
  }
}
