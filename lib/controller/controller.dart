import 'package:flutter/material.dart';
import 'package:teachent_app/common/enums.dart';
import 'package:teachent_app/common/data_manager.dart';
import 'package:teachent_app/model/objects/message.dart';

/// Base class for every controller
/// Contains dataManager object with most important references
abstract class BaseController {
  @protected
  final DataManager dataManager = DataManagerCreator.create();

  /// Method which creates all necessary objects for controller.
  /// Send requests to database to collect all required data for page.
  void init() {}

  /// Method which should be called in overridden dispose method in State class for StatefulWidget.
  /// If StatefulWidget is not used, then there is no need to override this method
  void dispose() {}
}

/// Base controller for search controllers
abstract class BaseSearchController extends BaseController {
  final _searchTextController = TextEditingController();
  String phrase = '';

  /// Returns text editiing controller for search bar
  TextEditingController get searchController => _searchTextController;

  /// Set [value] for [phrase]
  void setValue(String? value) {
    phrase = value ?? '';
  }

  /// Updates list of found people in database
  Future<void> updateFoundList(PersonType type) async {}

  /// Updates list of found teachers in database
  Future<void> updateFoundTeacherList(List<String> topicNames,
      List<String> toolNames, List<String> placeNames) async {}

  @override
  void dispose() {
    _searchTextController.dispose();
  }
}

/// Base class for TeacherRequestPageController and StudentRequestPageController
/// Contains dataManager object with most important references
abstract class BaseRequestPageController extends BaseController {
  /// Return true if there are any messages for the request
  bool get hasAnyMessages => false;

  /// Return number of messages for the request
  int get messagesCount => 0;

  /// Return list of messages
  List<MessageField> get messages => [];

  /// Send message to cooperator.
  void sendMessageAndRefresh(BuildContext context);

  /// Returns true if message was created by sender for given message [index]
  bool isSender(int index) {
    return messages[index].isSender;
  }

  final _textController = TextEditingController();
  String messageText = '';

  /// Returns text editing controller for message field
  TextEditingController get textController => _textController;

  /// Set [value] for [messageText]
  void setValue(String? value) {
    messageText = value ?? '';
  }

  @override
  void dispose() {
    _textController.dispose();
  }
}
