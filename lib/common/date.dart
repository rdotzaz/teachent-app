import 'package:flutter/material.dart';

/// Class responsible for parsing dates
class DateFormatter {
  /// Returns date in proper format: yyyy-MM-dd hh:mm
  static String getString(DateTime? dateTime) {
    return dateTime != null ? dateTime.toString().substring(0, 16) : '';
  }

  /// Method parses [date] as [DateTime] object
  static DateTime parse(String date) {
    return DateTime.parse(date);
  }

  /// Wrapper method for DateTime.tryParse
  static DateTime? tryParse(String? date) {
    return DateTime.tryParse(date ?? '');
  }

  /// Methods returns DateTime object after [timeOfDay] addition
  static DateTime addTime(DateTime dateTime, TimeOfDay timeOfDay) {
    return dateTime
        .add(Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute));
  }

  /// Methods returns TimeOfDay object based on [dateTime]
  static TimeOfDay getTime(DateTime dateTime) {
    return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
  }

  /// Method returns string representation of [timeofDay]
  static String timeString(TimeOfDay? timeOfDay) {
    final minute = timeOfDay?.minute ?? 0;
    var hour = timeOfDay?.hour ?? 0;
    final isPM = hour >= 12;
    if (isPM) {
      hour -= 12;
    }
    return '${hour >= 10 ? hour : '0' + hour.toString()}:${minute >= 10 ? minute : '0' + minute.toString()}';
  }

  /// Method returns string representation of [dateTime], but only hour and minute
  static String onlyTimeString(DateTime? dateTime) {
    if (dateTime == null) {
      return '';
    }
    final stringRepr = dateTime.toString();
    return stringRepr.substring(11, 16);
  }

  /// Method returns string representation of [dateTime], but only year, month and day
  static String onlyDateString(DateTime? dateTime) {
    if (dateTime == null) {
      return '';
    }
    final stringRepr = dateTime.toString();
    return stringRepr.substring(0, 10);
  }
}
