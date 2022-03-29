import 'package:flutter/material.dart';
import 'package:teachent_app/controller/controller.dart';
import 'package:teachent_app/model/objects/topic.dart';
import 'package:teachent_app/model/objects/tool.dart';
import 'package:teachent_app/model/objects/place.dart';

class TeacherCreationPageController extends BaseController {
  String name = '';
  String description = '';
  Set<String> topics = {};
  Set<String> tools = {};
  Set<String> places = {};

  int _pageNumber = 0;

  final _headerNames = [
    'What\'s your name?',
    'In what topics do you feel well?',
    'How\'d you like to work?'
  ];

  final allTopics = [
    Topic('Math', false),
    Topic('Computer Science', false),
    Topic('English', false),
    Topic('Spanish', false),
    Topic('Geography', false)
  ];

  final allTools = [Tool('Discord', false), Tool('Microsoft Teams', false)];

  final allPlaces = [
    Place('Wroclaw', false),
    Place('Warsaw', false),
    Place('Krakow', false),
    Place('Berlin', false),
    Place('London', false)
  ];

  final _pageViewController = PageController();
  final _topicTextFieldController = TextEditingController();

  PageController get pageController => _pageViewController;
  TextEditingController get topicTextFieldController =>
      _topicTextFieldController;
  String get headerName => _headerNames[_pageNumber];

  final _nameSubPageKey = GlobalKey<FormState>();

  GlobalKey<FormState> get nameSubPageKey => _nameSubPageKey;

  void moveToPage(int pageNumber) {
    _pageNumber = pageNumber;
    _pageViewController.animateToPage(pageNumber,
        duration: const Duration(milliseconds: 700), curve: Curves.ease);
  }

  String? validateName(String? name) {
    var isEmpty = name?.isEmpty ?? true;
    if (isEmpty) {
      return 'Name cannot be empty';
    }
    var length = name?.length ?? 0;
    if (length < 5) {
      return 'Name length must be greater than 4';
    }
    return null;
  }

  void setName(String? nameToSet) {
    name = nameToSet ?? '';
  }

  void setDescription(String? descriptionToSet) {
    description = descriptionToSet ?? '';
  }

  bool validateFields() {
    return _nameSubPageKey.currentState?.validate() ?? false;
  }

  String getOtherTopicText() {
    var text = _topicTextFieldController.value.text;
    _topicTextFieldController.clear();
    return text;
  }

  void addToAllTopics(Topic topic) {
    allTopics.add(topic);
  }

  void addToAllTools(Tool tool) {
    allTools.add(tool);
  }

  void addToAllPlaces(Place place) {
    allPlaces.add(place);
  }
}
