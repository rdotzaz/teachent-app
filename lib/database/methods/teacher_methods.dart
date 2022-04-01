import 'package:teachent_app/database/adapters/firebase_adapter.dart';

import '../../common/consts.dart';
import '../../model/db_objects/db_object.dart';
import '../../model/db_objects/teacher.dart';
import '../../model/objects/topic.dart';
import '../../model/objects/tool.dart';
import '../../model/objects/place.dart';

mixin TeacherDatabaseMethods {
  Future<void> addTeacher(Teacher teacher) async {
    print('Teacher');
    final wasAdded = await FirebaseRealTimeDatabaseAdapter.addDatabaseObject(
        DatabaseObjectName.teachers, teacher.key, teacher.toMap());
    return;
  }

  void update(KeyId teacherId) {}

  void deleteTeacher(KeyId teacherId) {}

  Map<String, dynamic> getMapFromField(
      Map<dynamic, dynamic> values, String field) {
    return {
      for (var entry in (values[field] as Map<dynamic, dynamic>).entries)
        (entry.key as String): true
    };
  }

  Future<Teacher?> getTeacher(KeyId userId) async {
    final teacherValues = await FirebaseRealTimeDatabaseAdapter.getObject(
        DatabaseObjectName.teachers, userId);
    if (teacherValues.isEmpty) {
      return null;
    }

    print('[Teachers methods] Teacher found');
    final topics = getMapFromField(teacherValues, 'topics');
    final topicList =
        topics.entries.map((topic) => Topic(topic.key, true)).toList();

    final tools = getMapFromField(teacherValues, 'tools');
    final toolList =
        tools.entries.map((tool) => Tool(tool.key.toString(), true)).toList();

    final places = getMapFromField(teacherValues, 'places');
    final placeList = places.entries
        .map((place) => Place(place.key.toString(), true))
        .toList();

    final requestIds = getMapFromField(teacherValues, 'requests');
    final requestList = requestIds.entries.map((id) => id.toString()).toList();

    final lessonDateIds = getMapFromField(teacherValues, 'lessonDates');
    final lessonDateList =
        lessonDateIds.entries.map((id) => id.toString()).toList();

    return Teacher(
        userId,
        teacherValues['name'] ?? '',
        teacherValues['description'] ?? '',
        topicList,
        toolList,
        placeList,
        teacherValues['averageRate'] ?? -1,
        requestList,
        lessonDateList);
  }
}
