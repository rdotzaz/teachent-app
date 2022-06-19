import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Class responsible for parsing dates
class DateFormatter {
  /// Returns date in proper format: yyyy-MM-dd hh:mm
  static String getString(DateTime? dateTime) {
    return dateTime != null
        ? DateFormat('yyyy-MM-dd hh:mm').format(dateTime)
        : '';
  }

  /// Wrapper method for DateTime.parse
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
    return '${timeOfDay?.hour ?? ''}:${minute > 10 ? minute : '0' + minute.toString()}';
  }

  /// Method returns string representation of [dateTime], but only hour and minute
  static String onlyTimeString(DateTime? dateTime) {
    return dateTime != null ? DateFormat('hh:mm').format(dateTime) : '';
  }

  /// Method returns string representation of [dateTime], but only year, month and day
  static String onlyDateString(DateTime? dateTime) {
    return dateTime != null ? DateFormat('yyyy-MM-dd').format(dateTime) : '';
  }
}
