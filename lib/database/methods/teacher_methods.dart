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
  }

  void update(KeyId teacherId) {}

  void deleteTeacher(KeyId teacherId) {}

  Map<String, dynamic> _getMapFromField(
      Map<dynamic, dynamic> values, String field) {
    if (values[field] == null) {
      return {};
    }
    return {
      for (var entry in (values[field] as Map<dynamic, dynamic>).entries)
        (entry.key as String): true
    };
  }

  Future<Teacher?> getTeacher(KeyId userId) async {
    final teacherValues = await FirebaseRealTimeDatabaseAdapter.getObject(
        DatabaseObjectName.teachers, userId);
    if (teacherValues.isEmpty) {
      print('No teacherValues found');
      return null;
    }
    return Teacher.fromMap(userId, teacherValues);
  }

  Teacher _addTeacherToList(String login, Map values) {
    final topics = _getMapFromField(values, 'topics');
    final topicList =
        topics.entries.map((topic) => Topic(topic.key, true)).toList();

    final tools = _getMapFromField(values, 'tools');
    final toolList =
        tools.entries.map((tool) => Tool(tool.key.toString(), true)).toList();

    final places = _getMapFromField(values, 'places');
    final placeList = places.entries
        .map((place) => Place(place.key.toString(), true))
        .toList();
    return Teacher.onlyKeyName(
        login, values['name'] ?? '', topicList, toolList, placeList);
  }

  Future<List<Teacher>> getTeachersByNamePart(String name) async {
    final teacherValues =
        await FirebaseRealTimeDatabaseAdapter.getObjectsByName(
            DatabaseObjectName.teachers, 'name', name);
    final teachers = <Teacher>[];
    teacherValues.forEach((login, teacherValue) {
      final teacher =
          Teacher.fromMap(login, teacherValue as Map<dynamic, dynamic>);
      teachers.add(teacher);
    });
    return teachers;
  }

  Future<List<Teacher>> getTeachersByParams(String name, List<String> topics,
      List<String> tools, List<String> places) async {
    final teachers = await getTeachersByNamePart(name);

    print(teachers.map((teacher) => teacher.name).toList());
    final filteredTeachers = <Teacher>[];
    for (final teacher in teachers) {
      final toolSet = teacher.tools.map((tool) => tool.name).toSet();
      final topicSet = teacher.topics.map((topic) => topic.name).toSet();
      final placeSet = teacher.places.map((place) => place.name).toSet();

      final commonTools = toolSet.intersection(tools.toSet());
      final commonTopics = topicSet.intersection(topics.toSet());
      final commonPlaces = placeSet.intersection(places.toSet());

      print(
          'Cond 1: ${toolSet.length}, ${topicSet.length}, ${placeSet.length}');
      if ((commonTools.length > 0 ||
              commonTopics.length > 0 ||
              commonPlaces.length > 0) ||
          (topics.isEmpty && tools.isEmpty && places.isEmpty)) {
        filteredTeachers.add(teacher);
      }
    }
    return filteredTeachers;
  }

  Future<void> addLessonDateKeyToTeacher(
      KeyId teacherId, KeyId lessonDateId) async {
    await FirebaseRealTimeDatabaseAdapter.addForeignKey(
        DatabaseObjectName.teachers,
        teacherId,
        DatabaseObjectName.lessonDates,
        lessonDateId);
  }

  Future<List<Teacher>> getTeachersByDates(List<KeyId> lessonDateIds) async {
    final teachers = <Teacher>[];
    for (final lessonDateId in lessonDateIds) {
      final teacherId = await FirebaseRealTimeDatabaseAdapter.getForeignKey(
          DatabaseObjectName.lessonDates, lessonDateId, 'teacherId');
      if (teacherId == DatabaseConsts.emptyKey) {
        continue;
      }
      final teacher = await getTeacher(teacherId);
      if (teacher == null) {
        continue;
      }
      teachers.add(teacher);
    }
    return teachers;
  }

  Future<void> addRequestIdToTeacher(KeyId teacherId, KeyId requestId) async {
    await FirebaseRealTimeDatabaseAdapter.addForeignKey(
        DatabaseObjectName.teachers,
        teacherId,
        DatabaseObjectName.requests,
        requestId);
  }
}
