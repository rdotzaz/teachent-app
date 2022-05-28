import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teachent_app/common/date.dart';

void main() {
  group('Date formatter', () {
    test('Try parse empty string', () {
      expect(DateFormatter.tryParse(''), null);
    });

    test('Parse vaild date string', () {
      final dateTime = DateFormatter.parse('2022-10-04 12:22');
      expect(dateTime, DateTime(2022, 10, 04, 12, 22));
    });

    test('Parse incorrect date', () {
      expect(() {
        DateFormatter.parse('2022-10012:22');
      }, throwsFormatException);
    });

    test('Add time', () {
      final newDate = DateFormatter.addTime(
          DateTime(2022, 05, 10), const TimeOfDay(hour: 10, minute: 22));
      expect(newDate, DateTime(2022, 05, 10, 10, 22));
    });

    test('Add time to datetime object with hours', () {
      final newDate = DateFormatter.addTime(
          DateTime(2022, 05, 10, 8, 10), const TimeOfDay(hour: 4, minute: 10));
      expect(newDate, DateTime(2022, 05, 10, 12, 20));
    });

    test('timeString method', () {
      expect(DateFormatter.timeString(const TimeOfDay(hour: 11, minute: 5)),
          '11:05');
      expect(DateFormatter.timeString(const TimeOfDay(hour: 10, minute: 0)),
          '10:00');
      expect(DateFormatter.timeString(null), ':00');
    });

    test('onlyTimeString method', () {
      expect(
          DateFormatter.onlyTimeString(DateTime(2022, 04, 04, 11, 8)), '11:08');
      expect(DateFormatter.onlyTimeString(DateTime(2022, 04, 04)), '12:00');
    });

    test('onlyDateString method', () {
      expect(
          DateFormatter.onlyDateString(DateTime(2022, 05, 11)), '2022-05-11');
      expect(DateFormatter.onlyDateString(DateTime(2022, 12, 1)), '2022-12-01');
    });
  });
}
