import 'package:flutter/material.dart';
import 'package:teachent_app/common/data_manager.dart';

abstract class BaseController {
  @protected
  final DataManager dataManager = DataManagerCreator.create();
}

abstract class BasePageController extends BaseController {
  void init();
  void switchPage();
  void dispose();
}
