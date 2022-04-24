import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:teachent_app/common/enums.dart';
import 'package:teachent_app/controller/controller.dart';
import 'package:teachent_app/controller/pages/student_request_page/bloc/request_topic_bloc.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';
import 'package:teachent_app/model/db_objects/lesson_date.dart';
import 'package:teachent_app/model/db_objects/request.dart';
import 'package:teachent_app/model/db_objects/student.dart';
import 'package:teachent_app/model/objects/tool.dart';
import 'package:teachent_app/model/objects/topic.dart';
import 'package:teachent_app/model/objects/place.dart';
import 'package:teachent_app/view/widgets/status_bottom_sheet.dart';

class TeacherRequestPageController extends BaseController {
  KeyId? teacherId;
  Student? student;
  LessonDate? lessonDate;

  Request request;

  bool hasChanged = false;
  String requestedDate = '';

  TeacherRequestPageController(this.request, this.teacherId, this.student, this.lessonDate);

  @override
  Future<void> init() async {
    requestedDate = request.requestedDate;
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
  String get date =>
      '${lessonDate?.weekday ?? ''}, ${lessonDate?.hourTime ?? ''}';
  bool get isCycled => lessonDate?.isCycled ?? false;
  int get price => lessonDate?.price ?? 0;
  List<Tool> get tools => lessonDate?.tools ?? [];
  List<Place> get places => lessonDate?.places ?? [];
  Topic get topic => request.topic;
  bool get hasStudentMessage => false;
  bool get wasOtherDateRequested => request.requestedDate != '';

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

  bool hasAdditionalInfo() {
    return request.status == RequestStatus.waiting &&
            request.requestedDate.isNotEmpty;
  }

  String getStatusAdditionalInfo() {
    String message = '';
    if (hasAdditionalInfo()) {
      message = 'Student requested date: ${request.requestedDate}';
    }
    return message;
  }

  void rejectNewDate() {
      hasChanged = true;
      requestedDate = '';
  }

  void restoreNewDate() {
      hasChanged = false;
      requestedDate = request.requestedDate;
  }

  Future<void> sendResponse(BuildContext context) async {
      if (hasChanged) {
          await dataManager.database.clearRequestedDate(request.requestId);
      }
      await dataManager.database.changeRequestStatus(request.requestId, RequestStatus.responded);

      await showSuccessMessageAsync(context, 'Response has been sent');

      Navigator.of(context).pop();
  }

  Future<void> acceptRequest(BuildContext context) async {}

  Future<void> rejectRequest(BuildContext context) async {}
}
