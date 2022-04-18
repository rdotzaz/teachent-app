import 'package:flutter/material.dart';
import 'package:teachent_app/controller/controller.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';
import 'package:teachent_app/model/db_objects/lesson_date.dart';
import 'package:teachent_app/model/db_objects/request.dart';
import 'package:teachent_app/model/db_objects/teacher.dart';
import 'package:teachent_app/model/objects/tool.dart';
import 'package:teachent_app/model/objects/place.dart';
import 'package:teachent_app/view/widgets/status_bottom_sheet.dart';

class RequestPageController extends BaseController {
  KeyId? requestId;
  KeyId? studentId;
  Teacher? teacher;
  Request? request;
  LessonDate? lessonDate;

  RequestPageController(
      this.requestId, this.studentId, this.teacher, this.lessonDate);

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

  String get teacherName => teacher?.name ?? '';
  String get date =>
      '${lessonDate?.weekday ?? ''}, ${lessonDate?.hourTime ?? ''}';
  bool get isCycled => lessonDate?.isCycled ?? false;
  int get price => lessonDate?.price ?? 0;
  List<Tool> get tools => lessonDate?.tools ?? [];
  List<Place> get places => lessonDate?.places ?? [];

  Future<void> sendRequest(BuildContext context) async {
    request = Request.noKey(lessonDate?.lessonDateId ?? '',
        teacher?.userId ?? '', studentId ?? '', 0);

    final requestKey = await dataManager.database.addRequest(request!);

    if (requestKey == null) {
      return;
    }
    await dataManager.database
        .addRequestIdToTeacher(teacher?.userId ?? '', requestKey);
    await dataManager.database
        .addRequestIdToStudent(studentId ?? '', requestKey);

    await showSuccessMessageAsync(context, 'Request has successfully sent');

    Navigator.of(context).pop();
  }
}
