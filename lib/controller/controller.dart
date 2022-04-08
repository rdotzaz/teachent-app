import 'package:flutter/material.dart';
import 'package:teachent_app/common/data_manager.dart';

/// Base class for every controller
/// Contains dataManager object with most important refernces
abstract class BaseController {
  @protected
  final DataManager dataManager = DataManagerCreator.create();

  void init() {}
  void dispose() {}
}

/// Base controller for search controllers
abstract class BaseSearchController extends BaseController {
  final _searchTextController = TextEditingController();
  String phrase = '';

  TextEditingController get searchController => _searchTextController;

  void setValue(String? value) {
    phrase = value ?? '';
  }
}
