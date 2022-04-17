import 'package:teachent_app/common/consts.dart';
import 'package:teachent_app/database/adapters/firebase_adapter.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';
import 'package:teachent_app/model/db_objects/lesson.dart';

mixin LessonDatabaseMethods {
  Future<Iterable<Lesson>> getLessonsByTeacherId(List<KeyId> lessonDateIds) async {
    final lessons = <Lesson>[];
    for (final lessonDateId in lessonDateIds) {
      final lessonValues = await FirebaseRealTimeDatabaseAdapter.getObject(
          DatabaseObjectName.lessons, lessonDateId);

      if (lessonValues.isEmpty) {
        continue;
      }
      lessons.add(Lesson.fromMap(lessonDateId, lessonValues));
    }
    return lessons;
  }
}
