import 'package:teachent_app/database/database.dart';

import '../../common/consts.dart';
import '../../model/db_objects/db_object.dart';
import '../../model/db_objects/teacher.dart';

/// Methods to maintain Teacher object in database
mixin TeacherDatabaseMethods on IDatabase {
  Future<void> addTeacher(Teacher teacher) async {
    await firebaseAdapter.addDatabaseObject(
        DatabaseObjectName.teachers, teacher.key, teacher.toMap());
  }

  Future<Teacher?> getTeacher(KeyId userId) async {
    final teacherValues = await firebaseAdapter.getObject(
        DatabaseObjectName.teachers, userId);
    if (teacherValues.isEmpty) {
      return null;
    }
    return Teacher.fromMap(userId, teacherValues);
  }

  Future<List<Teacher>> getTeachersByNamePart(String name) async {
    final teacherValues =
        await firebaseAdapter.getObjectsByName(
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
    await firebaseAdapter.updateField(
        DatabaseObjectName.teachers,
        teacherId,
        DatabaseObjectName.lessonDates,
        {lessonDateId: true});
  }

  Future<List<Teacher>> getTeachersByDates(List<KeyId> lessonDateIds) async {
    final teachers = <Teacher>[];
    for (final lessonDateId in lessonDateIds) {
      final teacherId = await firebaseAdapter.getForeignKey(
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
    await firebaseAdapter.updateField(
        DatabaseObjectName.teachers,
        teacherId,
        DatabaseObjectName.requests,
        {requestId: true});
  }

  Future<void> addReviewIdToTeacher(KeyId teacherId, KeyId reviewId) async {
    await firebaseAdapter.updateField(
        DatabaseObjectName.teachers,
        teacherId,
        DatabaseObjectName.reviews,
        {reviewId: true});
  }

  /// Update current average rate from teacher with [teacherId] with [newAverageRate] value
  Future<void> updateAverageRate(KeyId teacherId, double newAverageRate) async {
    await firebaseAdapter.updateField(
        DatabaseObjectName.teachers, teacherId, 'averageRate', newAverageRate);
  }
}
