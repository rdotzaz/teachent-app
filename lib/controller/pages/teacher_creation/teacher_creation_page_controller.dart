import 'package:flutter/material.dart';
import 'package:teachent_app/common/consts.dart';
import 'package:teachent_app/controller/controller.dart';
import 'package:teachent_app/controller/pages/teacher_creation/bloc/place_bloc.dart';
import 'package:teachent_app/controller/pages/teacher_creation/bloc/tool_bloc.dart';
import 'package:teachent_app/controller/pages/teacher_creation/bloc/topic_bloc.dart';
import 'package:teachent_app/model/db_objects/teacher.dart';
import 'package:teachent_app/model/objects/topic.dart';
import 'package:teachent_app/model/objects/tool.dart';
import 'package:teachent_app/model/objects/place.dart';
import 'package:teachent_app/view/pages/account_creation_page/account_creation_page.dart';

/// Controller for Teacher Creation Page
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

  final _headerNames = TeacherCreationPageConsts.headers;

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
    topicBloc.close();
    toolBloc.close();
    placeBloc.close();
    _pageViewController.dispose();
    _topicTextFieldController.dispose();
  }

  /// Retrive all available topics in database
  Future<void> initTopics() async {
    var topics = await dataManager.database.getAvailableTopics();
    _allTopics.addAll(topics);
    _allTopics.sort((t1, t2) => t1.name.compareTo(t2.name));
  }

  /// Retrive all available tools in database
  Future<void> initTools() async {
    var tools = await dataManager.database.getAvailableTools();
    _allTools.addAll(tools);
    _allTools.sort((t1, t2) => t1.name.compareTo(t2.name));
  }

  /// Retrive all available places in database
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

  /// Controler for PageView in TeacherCreationPage
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
      return TeacherCreationPageConsts.nameEmptyError;
    }
    var length = name?.length ?? 0;
    if (length < TeacherCreationPageConsts.nameLengthTreshold) {
      return TeacherCreationPageConsts.nameLengthError;
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

  /// Retrive value from topic TextField
  String getOtherTopicText() {
    var text = _topicTextFieldController.value.text;
    _topicTextFieldController.clear();
    return text;
  }

  /// Retrive value from TextField for tool or place adding
  String getOtherObjectText() {
    var text = _objectTextFieldController.value.text;
    _objectTextFieldController.clear();
    return text;
  }

  void showErrorMessage(BuildContext context, String info) {
    showErrorMessage(context, info);
  }

  /// Return true if topic is already in available topics
  /// Otherwise return false
  bool containsTopicInAll(Topic topic) {
    for (final t in _allTopics) {
      if (t.name == topic.name) {
        return true;
      }
    }
    return false;
  }

  /// Return true if tool is already in available tools
  /// Otherwise return false
  bool containsToolInAll(Tool tool) {
    for (final t in _allTools) {
      if (t.name == tool.name) {
        return true;
      }
    }
    return false;
  }

  /// Return true if place is already in available places
  /// Otherwise return false
  bool containsPlaceInAll(Place place) {
    for (final p in _allPlaces) {
      if (p.name == place.name) {
        return true;
      }
    }
    return false;
  }

  /// Method adds new topic to available topics.
  /// Topic added after clicking "Add other topic"
  void addToAllTopics(Topic topic) {
    _allTopics.add(topic);
    _allTopics.sort((t1, t2) => t1.name.compareTo(t2.name));
  }

  /// Method adds new tool to available tools.
  /// Topic added after clicking "Add other tool"
  void addToAllTools(Tool tool) {
    _allTools.add(tool);
    _allTools.sort((t1, t2) => t1.name.compareTo(t2.name));
  }

  /// Method adds new place to available places.
  /// Topic added after clicking "Add other place"
  void addToAllPlaces(Place place) {
    _allPlaces.add(place);
    _allPlaces.sort((p1, p2) => p1.name.compareTo(p2.name));
  }

  /// Go to Account Page. Create teacher object which can be add to database in Account Creation Page
  void goToLoginCreationPage(BuildContext context) {
    if (topics.isEmpty) {
      showErrorMessage(context, TeacherCreationPageConsts.noTopicSelected);
      return;
    } else if (tools.isEmpty && places.isEmpty) {
      showErrorMessage(context, TeacherCreationPageConsts.toolOrPlaceError);
      return;
    }

    var teacher = Teacher.noKey(
        name,
        description,
        topics.map((name) => Topic(name, true)).toList(),
        tools.map((name) => Tool(name, true)).toList(),
        places.map((name) => Place(name, true)).toList(),
        TeacherConsts.emptyRate, [], [], []);

    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => AccountCreationPage(teacher)));
  }
}
