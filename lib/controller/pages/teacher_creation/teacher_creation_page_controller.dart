import 'package:flutter/material.dart';
import 'package:teachent_app/controller/controller.dart';
import 'package:teachent_app/controller/pages/teacher_creation/bloc/place_bloc.dart';
import 'package:teachent_app/controller/pages/teacher_creation/bloc/tool_bloc.dart';
import 'package:teachent_app/controller/pages/teacher_creation/bloc/topic_bloc.dart';
import 'package:teachent_app/model/objects/topic.dart';
import 'package:teachent_app/model/objects/tool.dart';
import 'package:teachent_app/model/objects/place.dart';
import 'package:teachent_app/view/widgets/status_bottom_sheet.dart';

class TeacherCreationPageController extends BaseController {
  String name = '';
  String description = '';
  Set<String> topics = {};
  Set<String> tools = {};
  Set<String> places = {};

  late TopicBloc topicBloc;
  late ToolBloc toolBloc;
  late PlaceBloc placeBloc;

  int _pageNumber = 0;

  final _headerNames = [
    'What\'s your name?',
    'In what topics do you feel well?',
    'How\'d you like to work?'
  ];

  final List<Topic> _allTopics = [];

  final List<Tool> _allTools = [];

  final List<Place> _allPlaces = [];

  @override
  void init() {
    topicBloc = TopicBloc(this);
    toolBloc = ToolBloc(this);
    placeBloc = PlaceBloc(this);

    topicBloc.add(LoadAllTopicsEvent());
    toolBloc.add(LoadAllToolsEvent());
    placeBloc.add(LoadAllPlacesEvent());
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    _topicTextFieldController.dispose();
  }

  Future<void> initTopics() async {
    var topics = await dataManager.database.getAvailableTopics();
    _allTopics.addAll(topics);
    _allTopics.sort((t1, t2) => t1.name.compareTo(t2.name));
  }

  Future<void> initTools() async {
    var tools = await dataManager.database.getAvailableTools();
    _allTools.addAll(tools);
    _allTools.sort((t1, t2) => t1.name.compareTo(t2.name));
  }

  Future<void> initPlaces() async {
    var places = await dataManager.database.getAvailablePlaces();
    _allPlaces.addAll(places);
    _allPlaces.sort((p1, p2) => p1.name.compareTo(p2.name));
  }

  List<Topic> get topicList => _allTopics;
  List<Tool> get toolList => _allTools;
  List<Place> get placeList => _allPlaces;

  final _pageViewController = PageController();
  final _topicTextFieldController = TextEditingController();
  final _objectTextFieldController = TextEditingController();

  PageController get pageController => _pageViewController;
  TextEditingController get topicTextFieldController =>
      _topicTextFieldController;
  TextEditingController get objectTextFieldController =>
      _objectTextFieldController;
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

  String getOtherObjectText() {
    var text = _objectTextFieldController.value.text;
    _objectTextFieldController.clear();
    return text;
  }

  void showErrorMessage(BuildContext context, String info) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
        builder: (_) =>
            StatusBottomSheet(info: info, status: BottomSheetStatus.error));
  }

  bool containsTopicInAll(Topic topic) {
    for (final t in _allTopics) {
      if (t.name == topic.name) {
        return true;
      }
    }
    return false;
  }

  bool containsToolInAll(Tool tool) {
    for (final t in _allTools) {
      if (t.name == tool.name) {
        return true;
      }
    }
    return false;
  }

  bool containsPlaceInAll(Place place) {
    for (final p in _allPlaces) {
      if (p.name == place.name) {
        return true;
      }
    }
    return false;
  }

  void addToAllTopics(Topic topic) {
    _allTopics.add(topic);
    _allTopics.sort((t1, t2) => t1.name.compareTo(t2.name));
  }

  void addToAllTools(Tool tool) {
    _allTools.add(tool);
    _allTools.sort((t1, t2) => t1.name.compareTo(t2.name));
  }

  void addToAllPlaces(Place place) {
    _allPlaces.add(place);
    _allPlaces.sort((p1, p2) => p1.name.compareTo(p2.name));
  }
}
