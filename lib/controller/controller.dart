import 'package:flutter/material.dart';
import 'package:teachent_app/common/enums.dart';
import 'package:teachent_app/common/data_manager.dart';
import 'package:teachent_app/model/objects/message.dart';

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

  Future<void> updateFoundList(PersonType type) async {}
  Future<void> updateFoundTeacherList(List<String> topicNames,
      List<String> toolNames, List<String> placeNames) async {}
  

  @override
  void dispose() {
    _searchTextController.dispose();
  }
}

abstract class BaseRequestPageController extends BaseController {
  bool get hasAnyMessages => false;
  int get messagesCount => 0;
  List<MessageField> get messages => [];

  void sendMessageAndRefresh(Function refresh);
  
  bool isSender(int index) {
    return messages[index].isSender;
  }

  final _textController = TextEditingController();
  String messageText = '';

  TextEditingController get textController => _textController;

  void setValue(String? value) {
    messageText = value ?? '';
  }

  @override
  void dispose() {
    _textController.dispose();
  }
} 
