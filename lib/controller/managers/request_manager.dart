import 'package:flutter/material.dart';
import 'package:teachent_app/common/data_manager.dart';
import 'package:teachent_app/common/date.dart';
import 'package:teachent_app/common/enums.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';
import 'package:teachent_app/model/db_objects/lesson_date.dart';
import 'package:teachent_app/model/db_objects/request.dart';
import 'package:teachent_app/model/db_objects/student.dart';
import 'package:teachent_app/model/db_objects/teacher.dart';
import 'package:teachent_app/model/objects/topic.dart';
import 'package:teachent_app/model/objects/message.dart';

import 'lesson_date_manager.dart';
import 'lesson_manager.dart';

/// Class for request management
class RequestManager {
  /// Send [request] to [teacher]. Request will be sent by student with [studentId]
  static Future<void> sendNew(DataManager dataManager, Request request,
      Teacher? teacher, KeyId? studentId) async {
    final requestKey = await dataManager.database.addRequest(request);

    if (requestKey == null) {
      return;
    }
    await dataManager.database
        .addRequestIdToTeacher(teacher?.userId ?? '', requestKey);
    await dataManager.database
        .addRequestIdToStudent(studentId ?? '', requestKey);
  }

  /// Send response to teacher with [otherDate], [time] and [selectedTopic]
  static Future<void> sendStudentResponse(
      DataManager dataManager,
      Request request,
      DateTime otherDate,
      TimeOfDay time,
      Topic selectedTopic) async {
    await dataManager.database
        .changeRequestStatus(request.requestId, RequestStatus.waiting);

    final newDate = DateFormatter.addTime(otherDate, time);

    await dataManager.database.changeRequestedDate(request.requestId, newDate);
    await dataManager.database.changeRequestedDateStatus(
        request.requestId, RequestedDateStatus.requested);

    if (selectedTopic.name != request.topic.name) {
      await dataManager.database.changeTopic(request.requestId, selectedTopic);
    }
  }

  /// Send response to student with updated request [status]
  static Future<void> sendTeacherResponse(DataManager dataManager,
      Request request, RequestedDateStatus status) async {
    await dataManager.database
        .changeRequestedDateStatus(request.requestId, status);

    await dataManager.database
        .changeRequestStatus(request.requestId, RequestStatus.responded);
  }

  /// Accept [request] by teacher for [lessonDate].
  static Future<void> acceptRequest(DataManager dataManager, Request request,
      Student? student, LessonDate? lessonDate) async {
    if (request.requestedDate != null) {
      await dataManager.database.changeLessonDate(
          lessonDate?.lessonDateId ?? '', request.requestedDate!);
      lessonDate?.date == request.requestedDate!;
      await dataManager.database
          .changeCurrentDate(request.requestId, request.requestedDate!);
    }
    await dataManager.database.assignStudentToLessonDate(
        lessonDate?.lessonDateId ?? '', student?.userId ?? '');
    await dataManager.database.addLessonDateIdToStudent(
        student?.userId ?? '', lessonDate?.lessonDateId ?? '');
    await dataManager.database
        .changeRequestStatus(request.requestId, RequestStatus.accepted);

    await LessonDateManager.setDateAsNotFree(dataManager, lessonDate);

    final dateToAssign = request.requestedDate != null
        ? request.requestedDate!
        : lessonDate!.date;
    await LessonManager.createFirst(
        dataManager, student?.userId ?? '', lessonDate!, dateToAssign);
  }

  /// Reject [request] by teacher
  static Future<void> rejectRequest(
      DataManager dataManager, Request request) async {
    await dataManager.database
        .changeRequestStatus(request.requestId, RequestStatus.rejected);
  }

  /// Send message by teacher to student
  static Future<void> sendTeacherMessage(
      DataManager dataManager, Request request, String message) async {
    await dataManager.database.addTeacherMessage(
        request.requestId, MessageRecord(message, DateTime.now()));
  }

  /// Send message by student to teacher
  static Future<void> sendStudentMessage(
      DataManager dataManager, Request request, String message) async {
    await dataManager.database.addStudentMessage(
        request.requestId, MessageRecord(message, DateTime.now()));
  }
}
