import 'package:teachent_app/common/firebase_enums.dart';
import 'package:teachent_app/database/adapters/firebase_adapter.dart';

import '../../common/consts.dart';
import '../../model/db_objects/db_object.dart';
import '../../model/db_objects/teacher.dart';

/// Methods to maintain Teacher object in database
mixin TeacherDatabaseMethods {
  Future<void> addTeacher(Teacher teacher) async {
    await FirebaseRealTimeDatabaseAdapter.addDatabaseObject(
        DatabaseObjectName.teachers, teacher.key, teacher.toMap());
  }

  Future<Teacher?> getTeacher(KeyId userId) async {
    final response = await FirebaseRealTimeDatabaseAdapter.getObject(
        DatabaseObjectName.teachers, userId);
    if (response.status == FirebaseResponseStatus.failure) {
      return null;
    }
    return Teacher.fromMap(userId, response.data);
  }

  Future<List<Teacher>> getTeachersByNamePart(String name) async {
    final response = await FirebaseRealTimeDatabaseAdapter.getObjectsByName(
        DatabaseObjectName.teachers, 'name', name);
    final teachers = <Teacher>[];
    response.data.forEach((login, teacherValue) {
      final teacher =
          Teacher.fromMap(login, teacherValue as Map<dynamic, dynamic>);
      teachers.add(teacher);
    });
    return teachers;
  }

  Future<List<Teacher>> getTeachersByParams(String name, List<String> topics,
      List<String> tools, List<String> places) async {
    final teachers = await getTeachersByNamePart(name);

    final filteredTeachers = <Teacher>[];
    for (final teacher in teachers) {
      final toolSet = teacher.tools.map((tool) => tool.name).toSet();
      final topicSet = teacher.topics.map((topic) => topic.name).toSet();
      final placeSet = teacher.places.map((place) => place.name).toSet();

      final commonTools = toolSet.intersection(tools.toSet());
      final commonTopics = topicSet.intersection(topics.toSet());
      final commonPlaces = placeSet.intersection(places.toSet());

      if ((commonTools.isNotEmpty ||
              commonTopics.isNotEmpty ||
              commonPlaces.isNotEmpty) ||
          (topics.isEmpty && tools.isEmpty && places.isEmpty)) {
        filteredTeachers.add(teacher);
      }
    }
    return filteredTeachers;
  }

  Future<void> addLessonDateKeyToTeacher(
      KeyId teacherId, KeyId lessonDateId) async {
    await FirebaseRealTimeDatabaseAdapter.updateField(
        DatabaseObjectName.teachers,
        teacherId,
        DatabaseObjectName.lessonDates,
        {lessonDateId: true});
  }

  Future<List<Teacher>> getTeachersByDates(List<KeyId> lessonDateIds) async {
    final teachers = <KeyId, Teacher>{};
    for (final lessonDateId in lessonDateIds) {
      final response = await FirebaseRealTimeDatabaseAdapter.getForeignKey(
          DatabaseObjectName.lessonDates, lessonDateId, 'teacherId');
      if (response.status == FirebaseResponseStatus.failure) {
        continue;
      }
      final teacher = await getTeacher(response.data);
      if (teacher == null) {
        continue;
      }
      teachers[teacher.userId] = teacher;
    }
    return teachers.entries.map((e) => e.value).toList();
  }

  Future<void> addRequestIdToTeacher(KeyId teacherId, KeyId requestId) async {
    await FirebaseRealTimeDatabaseAdapter.updateField(
        DatabaseObjectName.teachers,
        teacherId,
        DatabaseObjectName.requests,
        {requestId: true});
  }

  Future<void> addReviewIdToTeacher(KeyId teacherId, KeyId reviewId) async {
    await FirebaseRealTimeDatabaseAdapter.updateField(
        DatabaseObjectName.teachers,
        teacherId,
        DatabaseObjectName.reviews,
        {reviewId: true});
  }

  /// Update current average rate from teacher with [teacherId] with [newAverageRate] value
  Future<void> updateAverageRate(KeyId teacherId, int newAverageRate) async {
    await FirebaseRealTimeDatabaseAdapter.updateField(
        DatabaseObjectName.teachers, teacherId, 'averageRate', newAverageRate);
  }
}
