import 'package:teachent_app/common/consts.dart';
import 'package:teachent_app/common/data_manager.dart';
import 'package:teachent_app/common/enums.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';
import 'package:teachent_app/model/db_objects/lesson_date.dart';

class LessonDateManager {
  static Future<void> setDateAsFree(
      DataManager dataManager, LessonDate? lessonDate) async {
    await dataManager.database
        .changeLessonDateIsFree(lessonDate?.lessonDateId ?? '', true);
  }

  static Future<void> setDateAsNotFree(
      DataManager dataManager, LessonDate? lessonDate) async {
    await dataManager.database
        .changeLessonDateIsFree(lessonDate?.lessonDateId ?? '', false);
  }
}
