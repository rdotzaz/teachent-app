import 'package:flutter/material.dart';
import 'package:teachent_app/controller/controller.dart';

class SearchPageController extends BaseController {
  final _searchTextController = TextEditingController();
  String phrase = '';

  TextEditingController get searchController => _searchTextController;

  void setValue(String? value) {
    phrase = value ?? '';
  }
}
