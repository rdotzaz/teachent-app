import 'package:flutter/material.dart';
import 'package:teachent_app/common/data_manager.dart';
import 'package:teachent_app/common/enums.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';
import 'package:teachent_app/model/db_objects/lesson_date.dart';
import 'package:teachent_app/model/db_objects/request.dart';
import 'package:teachent_app/model/db_objects/teacher.dart';
import 'package:teachent_app/model/objects/topic.dart';
import 'package:teachent_app/model/objects/message.dart';

import 'lesson_date_manager.dart';

class RequestManager {
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

  static Future<void> sendStudentResponse(
      DataManager dataManager,
      Request request,
      DateTime? otherDate,
      TimeOfDay? time,
      Topic selectedTopic) async {
    await dataManager.database
        .changeRequestStatus(request.requestId, RequestStatus.waiting);

    final dateChanged = otherDate != null && otherDate != request.requestedDate;
    DateTime? newDate;
    if (dateChanged) {
      newDate = otherDate;
    }

    final timeChanged = time !=
        TimeOfDay(
            hour: request.requestedDate?.hour ?? 0,
            minute: request.requestedDate?.minute ?? 0);
    if (timeChanged && time != null) {
      if (newDate == null) {
        final newCurrentDate = DateTime(
            request.currentDate.year,
            request.currentDate.month,
            request.currentDate.day,
            time.hour,
            time.minute);
        newDate = newCurrentDate;
      } else {
        final newCurrentDate = DateTime(
            newDate.year, newDate.month, newDate.day, time.hour, time.minute);
        newDate = newCurrentDate;
      }
    }
    if (newDate != null) {
      await dataManager.database
          .changeRequestedDate(request.requestId, newDate);
      await dataManager.database.changeRequestedDateStatus(
          request.requestId, RequestedDateStatus.requested);
    }

    if (selectedTopic.name != request.topic.name) {
      await dataManager.database.changeTopic(request.requestId, selectedTopic);
    }
  }

  static Future<void> sendTeacherResponse(DataManager dataManager,
      Request request, RequestedDateStatus status) async {
    await dataManager.database
        .changeRequestedDateStatus(request.requestId, status);

    await dataManager.database
        .changeRequestStatus(request.requestId, RequestStatus.responded);
  }

  static Future<void> acceptRequest(DataManager dataManager, Request request,
      KeyId studentId, LessonDate? lessonDate) async {
    if (request.requestedDate != null) {
      await dataManager.database.changeLessonDate(
          lessonDate?.lessonDateId ?? '', request.requestedDate!);
      lessonDate?.date == request.requestedDate!;
      await dataManager.database
          .changeCurrentDate(request.requestId, request.requestedDate!);
    }
    await dataManager.database
        .assignStudentToLessonDate(lessonDate?.lessonDateId ?? '', studentId);
    await dataManager.database
        .addLessonDateIdToStudent(studentId, lessonDate?.lessonDateId ?? '');
    await dataManager.database
        .changeRequestStatus(request.requestId, RequestStatus.accepted);

    await LessonDateManager.setDateAsNotFree(dataManager, lessonDate);
  }

  static Future<void> rejectRequest(
      DataManager dataManager, Request request) async {
    await dataManager.database
        .changeRequestStatus(request.requestId, RequestStatus.rejected);
  }

  static Future<void> sendTeacherMessage(
      DataManager dataManager, Request request, String message) async {
    await dataManager.database.addTeacherMessage(
        request.requestId, MessageRecord(message, DateTime.now()));
  }

  static Future<void> sendStudentMessage(
      DataManager dataManager, Request request, String message) async {
    await dataManager.database.addStudentMessage(
        request.requestId, MessageRecord(message, DateTime.now()));
  }
}
