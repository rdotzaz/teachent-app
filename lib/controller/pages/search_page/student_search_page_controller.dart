import 'package:flutter/material.dart';
import 'package:teachent_app/controller/controller.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';
import 'package:teachent_app/model/db_objects/teacher.dart';
import 'package:teachent_app/model/objects/topic.dart';
import 'package:teachent_app/model/objects/tool.dart';
import 'package:teachent_app/model/objects/place.dart';
import 'package:teachent_app/view/pages/teacher_profile_page/teacher_profile_page.dart';

/// Controler for Student Search Page
class StudentSearchPageController extends BaseSearchController {
  final KeyId studentId;
  StudentSearchPageController(this.studentId);

  final List<Topic> _allTopics = [];
  final List<Place> _allPlaces = [];
  final List<Tool> _allTools = [];

  final List<Teacher> _foundTeachers = [];

  /// Get all available topics
  List<Topic> get topics => _allTopics;

  /// Get all available places
  List<Place> get places => _allPlaces;

  /// Get all available tools
  List<Tool> get tools => _allTools;

  /// Get found teachers
  List<Teacher> get teachers => _foundTeachers;

  /// Methods retreives all available topics from database
  Future<void> initAllTopics() async {
    final topics = await dataManager.database.getAvailableTopics();
    _allTopics.addAll(topics);
  }

  /// Methods retreives all available tools from database
  Future<void> initAllTools() async {
    final tools = await dataManager.database.getAvailableTools();
    _allTools.addAll(tools);
  }

  /// Methods retreives all available places from database
  Future<void> initAllPlaces() async {
    final places = await dataManager.database.getAvailablePlaces();
    _allPlaces.addAll(places);
  }

  @override
  Future<void> updateFoundTeacherList(List<String> topicNames,
      List<String> toolNames, List<String> placeNames) async {
    _foundTeachers.clear();
    final teachers = await dataManager.database
        .getTeachersByParams(phrase, topicNames, toolNames, placeNames);
    _foundTeachers.addAll(teachers);
  }

  /// Methods triggers TeacherProfilePage for teacher from foundTeachers array at [teacherIndex]
  void goToProfilePage(BuildContext context, int teacherIndex) {
    final teacher = _foundTeachers[teacherIndex];

    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) =>
            TeacherProfilePage(teacher: teacher, studentId: studentId)));
  }
}
