import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:teachent_app/common/enums.dart';
import 'package:teachent_app/common/enum_functions.dart';
import 'package:teachent_app/controller/controller.dart';
import 'package:teachent_app/controller/pages/lesson_date_creation/bloc/freq_bloc.dart';
import 'package:teachent_app/controller/pages/lesson_date_creation/bloc/tool_bloc.dart';
import 'package:teachent_app/controller/pages/lesson_date_creation/bloc/place_bloc.dart';
import 'package:teachent_app/model/db_objects/lesson_date.dart';
import 'package:teachent_app/model/db_objects/teacher.dart';
import 'package:teachent_app/model/objects/tool.dart';
import 'package:teachent_app/model/objects/place.dart';

/// Controller for LessonDate Creation Page
class LessonDateCreationPageController extends BaseController {
  final Teacher teacher;
  final void Function() refresh;
  LessonDateCreationPageController(this.teacher, this.refresh);

  final _formKey = GlobalKey<FormState>();
  final List<Tool> _tools = [];
  final List<Place> _places = [];

  /// Available lesson frequences.
  /// TODO - Move [_freqs] list to database
  final List<String> _freqs = [
    'Single',
    'Daily',
    'Weekly',
    'Biweekly',
    'Monthly'
  ];

  /// Key for form widget
  GlobalKey<FormState> get formKey => _formKey;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  int _duration = 60;
  int _price = 50;
  bool _isCycled = false;
  int _selectedFreqIndex = 0;

  late FrequencyBloc freqBloc;
  late ToolBloc toolBloc;
  late PlaceBloc placeBloc;

  @override
  void init() {
    _tools.addAll(teacher.tools.map((t) => Tool(t.name, false)).toList());
    _places.addAll(teacher.places.map((p) => Place(p.name, false)).toList());

    freqBloc = FrequencyBloc(this);
    toolBloc = ToolBloc(this);
    placeBloc = PlaceBloc(this);
  }

  /// Lesson date established by teacher
  DateTime get date => _selectedDate.add(Duration(hours: _selectedTime.hour, minutes: _selectedTime.minute));
  String time(BuildContext context) => _selectedTime.format(context);
  int get lessonDuration => _duration;
  int get price => _price;
  List<Tool> get tools => _tools;
  List<Place> get places => _places;
  List<String> get lessonFrequencies => _freqs;
  bool get isCycled => _isCycled;

  bool isFreqSelected(int index) => index == _selectedFreqIndex;

  /// Change lesson frequence
  void toggleFreq(int index) {
    _selectedFreqIndex = index;
    refresh();
  }

  /// Date picker
  Future<void> enableDatePicker(BuildContext context) async {
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: _selectedDate,
        lastDate: DateTime(2040));

    if (pickedDate == null) {
      return;
    }

    final areDatesDiffer = pickedDate != _selectedDate;
    _selectedDate = pickedDate;
    if (areDatesDiffer) {
      refresh();
    }
  }

  /// Time picker
  Future<void> enableTimePicker(BuildContext context) async {
    final pickedTime = await showTimePicker(
        context: context,
        initialTime: _selectedTime,
        builder: (context, child) {
          return MediaQuery(
              data:
                  MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
              child: child!);
        });

    if (pickedTime == null) {
      return;
    }

    final areTimesDiffer = pickedTime != _selectedTime;
    _selectedTime = pickedTime;
    if (areTimesDiffer) {
      refresh();
    }
  }

  String? validateDuration(String? duration) {
    final durationInt = int.tryParse(duration ?? '');
    if (durationInt == null) {
      return null;
    }
    if (durationInt < 10) {
      return 'Duration cannot be less than 10';
    } else if (durationInt > 1000) {
      return 'Duration cannot be greater than 1000';
    }
    return null;
  }

  void setDuration(String? durationToSet) {
    _duration = int.tryParse(durationToSet ?? '') ?? 60;
  }

  String? validatePrice(String? price) {
    final priceInt = int.tryParse(price ?? '');
    if (priceInt == null) {
      return null;
    }
    if (priceInt < 0) {
      return 'Price cannot be negative';
    }
    return null;
  }

  void setPrice(String? priceToSet) {
    _price = int.tryParse(priceToSet ?? '') ?? 50;
  }

  void toggleCycleCheck() {
    _isCycled = !_isCycled;
  }

  /// Get color for selected checkbox based on checkbox state
  /// Return blue if chekcbox selected, white otherwise
  Color getCycledCheckBoxColor(Set<MaterialState> checkBoxStates) {
    if (checkBoxStates.contains(MaterialState.pressed)) {
      return Colors.white;
    }
    return Colors.blue;
  }

  Future<void> validateForm(BuildContext context) async {
    final toolIndexes = toolBloc.state;
    final placeIndexes = placeBloc.state;

    toolIndexes.asMap().forEach((i, isMarked) => _tools[i].marked = isMarked);
    placeIndexes.asMap().forEach((i, isMarked) => _places[i].marked = isMarked);

    final tools = _tools.where((t) => t.marked).toList();
    final places = _places.where((p) => p.marked).toList();

    final lessonDate = LessonDate.init(teacher.userId, date,
        isCycled, getCycleByValue(freqBloc.state), price, tools, places);

    final lessonDateKey = await dataManager.database.addLessonDate(lessonDate);
    await dataManager.database
        .addLessonDateKeyToTeacher(teacher.userId, lessonDateKey);

    Navigator.of(context).pop(true);
  }
}
