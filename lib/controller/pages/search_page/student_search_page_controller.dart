import 'package:teachent_app/controller/controller.dart';
import 'package:teachent_app/model/db_objects/teacher.dart';
import 'package:teachent_app/model/objects/topic.dart';
import 'package:teachent_app/model/objects/tool.dart';
import 'package:teachent_app/model/objects/place.dart';

/// Controler for Student Search Page
class StudentSearchPageController extends BaseSearchController {
  final List<Topic> _allTopics = [];
  final List<Place> _allPlaces = [];
  final List<Tool> _allTools = [];

  final List<Teacher> _foundTeachers = [];

  List<Topic> get topics => _allTopics;
  List<Place> get places => _allPlaces;
  List<Tool> get tools => _allTools;
  List<Teacher> get teachers => _foundTeachers;

  Future<void> initAllTopics() async {
    final topics = await dataManager.database.getAvailableTopics();
    _allTopics.addAll(topics);
  }

  Future<void> initAllTools() async {
    final tools = await dataManager.database.getAvailableTools();
    _allTools.addAll(tools);
  }

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
}
