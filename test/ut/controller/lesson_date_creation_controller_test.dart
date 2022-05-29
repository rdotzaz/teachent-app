import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teachent_app/common/date.dart';
import 'package:teachent_app/controller/pages/lesson_date_creation/lesson_date_creation_controller.dart';
import 'package:teachent_app/model/db_objects/teacher.dart';
import 'package:teachent_app/model/objects/place.dart';
import 'package:teachent_app/model/objects/topic.dart';

Teacher createTeacher() {
  return Teacher(
      'userId',
      'John Smith',
      'description',
      [Topic('Math', true), Topic('Computer Sciene', true)],
      [],
      [Place('Warsaw', true)],
      0,
      [],
      [],
      []);
}

void main() {
  late LessonDateCreationPageController lessonDateCreationController;

  group('Date and time', () {
    setUp(() {
      lessonDateCreationController =
          LessonDateCreationPageController(createTeacher(), () {});
    });
    test('Initial date and time are default', () {
      expect(lessonDateCreationController.date,
          DateFormatter.onlyDateString(DateTime.now()));
      expect(lessonDateCreationController.time,
          DateFormatter.timeString(const TimeOfDay(hour: 12, minute: 0)));
    });

    test('Do not set new date. setPossibleNewDate should not set new date', () {
      final oldDate = lessonDateCreationController.date;
      lessonDateCreationController.setPossibleNewDate(null);
      expect(lessonDateCreationController.date, oldDate);
    });

    test('Set new date. setPossibleNewDate should set new date', () {
      final oldDate = lessonDateCreationController.date;
      final newDateTime = DateTime(2022, 10, 5);
      lessonDateCreationController.setPossibleNewDate(newDateTime);
      expect(lessonDateCreationController.date == oldDate, false);
      expect(lessonDateCreationController.date,
          DateFormatter.onlyDateString(newDateTime));
    });

    test('Set new time same as old. setPossibleNewDate should not set new time',
        () {
      final oldTime = lessonDateCreationController.time;
      const newTimeOfDay = TimeOfDay(hour: 12, minute: 0);
      lessonDateCreationController.setPossibleNewTime(newTimeOfDay);
      expect(lessonDateCreationController.time == oldTime, true);
      expect(lessonDateCreationController.time,
          DateFormatter.timeString(newTimeOfDay));
    });

    test('Set new time. setPossibleNewDate should set new time', () {
      final oldTime = lessonDateCreationController.time;
      const newTimeOfDay = TimeOfDay(hour: 12, minute: 5);
      lessonDateCreationController.setPossibleNewTime(newTimeOfDay);
      expect(lessonDateCreationController.time == oldTime, false);
      expect(lessonDateCreationController.time,
          DateFormatter.timeString(newTimeOfDay));
    });
  });

  group('Price and duration', () {
    setUp(() {
      lessonDateCreationController =
          LessonDateCreationPageController(createTeacher(), () {});
    });

    test('Validate incorrect duration', () {
      expect(lessonDateCreationController.validateDuration('-20'),
          'Duration cannot be less than 10');
    });

    test('Validate too large duration', () {
      expect(lessonDateCreationController.validateDuration('1230'),
          'Duration cannot be greater than 1000');
    });

    test('Validate correct duration', () {
      expect(lessonDateCreationController.validateDuration('120'), null);
    });

    test('Validate empty price', () {
      expect(lessonDateCreationController.validatePrice(''),
          'Price cannot be null');
    });

    test('Validate negative price', () {
      expect(lessonDateCreationController.validatePrice('-10'),
          'Price cannot be negative');
    });

    test('Validate correct price', () {
      expect(lessonDateCreationController.validatePrice('20'), null);
    });
  });
}
