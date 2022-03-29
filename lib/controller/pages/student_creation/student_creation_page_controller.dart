import 'package:flutter/material.dart';
import 'package:teachent_app/controller/controller.dart';
import 'package:teachent_app/model/objects/education_level.dart';
import 'package:teachent_app/model/objects/place.dart';

class StudentCreationPageController extends BaseController {
  String name = '';
  String educationLevel = '';
  String place = '';

  int _pageNumber = 0;
  final _pageViewController = PageController();

  final _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> get formKey => _formKey;
  PageController get pageController => _pageViewController;

  final educationLevels = [
    EducationLevel('Primiary', false),
    EducationLevel('High School', false),
    EducationLevel('University', false)
  ];

  final places = [
    Place('Wroclaw', false),
    Place('Warsaw', false),
    Place('Krakow', false),
    Place('Berlin', false),
    Place('London', false)
  ];

  final _headerNames = ['What\'s your name?', 'Choose your education level'];

  String get headerName => _headerNames[_pageNumber];

  void moveToPage(int pageNumber) {
    _pageNumber = pageNumber;
    _pageViewController.animateToPage(pageNumber,
        duration: const Duration(milliseconds: 700), curve: Curves.ease);
  }

  bool validateFields() {
    return _formKey.currentState?.validate() ?? false;
  }
}
