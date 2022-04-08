import 'package:flutter/material.dart';
import 'package:teachent_app/common/data_manager.dart';

abstract class BaseController {
  @protected
  final DataManager dataManager = DataManagerCreator.create();

  void init() {}
  void dispose() {}
}

enum PersonType { all, teachers, students }

abstract class BaseSearchController extends BaseController {
  final _searchTextController = TextEditingController();
  String phrase = '';

  TextEditingController get searchController => _searchTextController;

  void setValue(String? value) {
    phrase = value ?? '';
  }

  Future<void> updateFoundList(PersonType type) async {}
  Future<void> updateFoundTeacherList(
    List<String> topicNames,
    List<String> toolNames, List<String> placeNames) async {}
}
