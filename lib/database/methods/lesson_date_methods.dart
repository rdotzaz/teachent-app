import 'package:teachent_app/common/consts.dart';
import 'package:teachent_app/database/adapters/firebase_adapter.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';
import 'package:teachent_app/model/db_objects/lesson_date.dart';

mixin LessonDateDatabaseMethods {
  Future<Iterable<LessonDate>> getLessonDates(List<KeyId> lessonDateIds) async {
    final dates = <LessonDate>[];
    for (final lessonDateId in lessonDateIds) {
      final dateValues = await FirebaseRealTimeDatabaseAdapter.getObject(
          DatabaseObjectName.lessonDates, lessonDateId);

      if (dateValues.isEmpty) {
        continue;
      }
      dates.add(LessonDate.fromMap(lessonDateId, dateValues));
    }
    return dates;
  }

  Future<KeyId> addLessonDate(LessonDate lessonDate) async {
    final key = await FirebaseRealTimeDatabaseAdapter.addDatabaseObjectWithNewKey(
        DatabaseObjectName.lessonDates, lessonDate.toMap());
    
    if (key != null) {
      print('LessonDate has been added');
    }
    return key;
  }
}