import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateFormatter {
  static String getString(DateTime? dateTime) {
    return dateTime != null
        ? DateFormat('yyyy-MM-dd hh:mm').format(dateTime)
        : '';
  }

  static DateTime parse(String date) {
    return DateTime.parse(date);
  }

  static DateTime? tryParse(String? date) {
    return DateTime.tryParse(date ?? '');
  }

  static DateTime addTime(DateTime dateTime, TimeOfDay timeOfDay) {
    return dateTime
        .add(Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute));
  }

  static TimeOfDay getTime(DateTime dateTime) {
    return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
  }

  static String timeString(TimeOfDay? timeOfDay) {
    final minute = timeOfDay?.minute ?? 0;
    return '${timeOfDay?.hour ?? ''}:${minute != 0 ? minute : '00'}';
  }

  static String onlyTimeString(DateTime? dateTime) {
    return dateTime != null ? DateFormat('hh:mm').format(dateTime) : '';
  }

  static String onlyDateString(DateTime? dateTime) {
    return dateTime != null ? DateFormat('yyyy-MM-dd').format(dateTime) : '';
  }
}
