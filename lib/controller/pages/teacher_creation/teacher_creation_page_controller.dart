import 'package:flutter/material.dart';
import 'package:teachent_app/controller/controller.dart';
import 'package:teachent_app/model/objects/place.dart';
import 'package:teachent_app/model/objects/tool.dart';
import 'package:teachent_app/model/objects/topic.dart';

class TeacherCreationPageController extends BaseController {
  String name = '';
  String description = '';
  List<Topic> topics = [];
  List<Tool> tools = [];
  List<Place> places = [];

  int _pageNumber = 0;

  final _headerNames = [
    'What\'s your name?',
    'In what topics do you feel well?',
    'How\'d you like to work?'
  ];
  final tempAllTopics = [
    'Math',
    'Computer Science',
    'English',
    'Spanish',
    'Geography',
    'Biology',
    'Chemistry'
  ];

  final _pageViewController = PageController();

  PageController get pageController => _pageViewController;
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
}
