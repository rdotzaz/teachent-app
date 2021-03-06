import 'package:flutter/material.dart';
import 'package:teachent_app/common/date.dart';
import 'package:teachent_app/common/enum_functions.dart';
import 'package:teachent_app/common/enums.dart';
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
  TimeOfDay _selectedTime = const TimeOfDay(hour: 12, minute: 0);
  int _duration = 60;
  int _price = 50;
  int _selectedFreqIndex = 0;

  /// [FrequencyBloc] to manage state of frequency chips on page
  late FrequencyBloc freqBloc;

  /// [ToolBloc] to manage state of tool chips on page
  late ToolBloc toolBloc;

  /// [PlaceBloc] to manage state of place chips on page
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
  String get date => DateFormatter.onlyDateString(_selectedDate);

  /// Time of day established by teacher
  String get time => DateFormatter.timeString(_selectedTime);

  /// Lesson duration in minutes
  int get lessonDuration => _duration;

  /// Price for single lesson unit
  int get price => _price;

  /// List of available tools
  List<Tool> get tools => _tools;

  /// List of available places
  List<Place> get places => _places;

  /// List of available lesson frequencies
  List<String> get lessonFrequencies => _freqs;

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
    setPossibleNewDate(pickedDate);
  }

  /// Method sets new date if [pickedDate] is not the same as previously selected date
  void setPossibleNewDate(DateTime? pickedDate) {
    if (pickedDate == null) {
      return;
    }

    final areDatesDiffer = pickedDate != _selectedDate;
    _selectedDate = pickedDate;
    if (areDatesDiffer) {
      refresh();
    }
  }

  /// Enable time picker for user
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
    setPossibleNewTime(pickedTime);
  }

  /// Method sets new time of day if [pickedTime] is not the same as previously selected time
  void setPossibleNewTime(TimeOfDay? pickedTime) {
    if (pickedTime == null) {
      return;
    }

    final areTimesDiffer = pickedTime != _selectedTime;
    _selectedTime = pickedTime;
    if (areTimesDiffer) {
      refresh();
    }
  }

  /// Validate lesson duration
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

  /// Set [durationToSet] as new lesson duration.
  /// If duration setting fails, then default value (60 minutes) will be set
  void setDuration(String? durationToSet) {
    _duration = int.tryParse(durationToSet ?? '') ?? 60;
  }

  /// Validate given [price]
  String? validatePrice(String? price) {
    final priceInt = int.tryParse(price ?? '');
    if (priceInt == null) {
      return 'Price cannot be null';
    }
    if (priceInt < 0) {
      return 'Price cannot be negative';
    }
    return null;
  }

  /// Set [priceToSet] as new price.
  /// If price setting fails, then default value (50) will be set
  void setPrice(String? priceToSet) {
    _price = int.tryParse(priceToSet ?? '') ?? 50;
  }

  /// Get color for selected checkbox based on checkbox state
  /// Return blue if chekcbox selected, white otherwise
  Color getCycledCheckBoxColor(Set<MaterialState> checkBoxStates) {
    if (checkBoxStates.contains(MaterialState.pressed)) {
      return Colors.white;
    }
    return Colors.blue;
  }

  /// Validate lesson date creation form.
  Future<void> validateForm(BuildContext context) async {
    final toolIndexes = toolBloc.state;
    final placeIndexes = placeBloc.state;

    toolIndexes.asMap().forEach((i, isMarked) => _tools[i].marked = isMarked);
    placeIndexes.asMap().forEach((i, isMarked) => _places[i].marked = isMarked);

    final tools = _tools.where((t) => t.marked).toList();
    final places = _places.where((p) => p.marked).toList();

    final lessonDate = LessonDate.init(
        teacher.userId,
        DateFormatter.addTime(_selectedDate, _selectedTime),
        freqBloc.state != CycleType.single.value,
        getCycleByValue(freqBloc.state),
        price,
        tools,
        places);

    final lessonDateKey = await dataManager.database.addLessonDate(lessonDate);
    await dataManager.database
        .addLessonDateKeyToTeacher(teacher.userId, lessonDateKey);

    Navigator.of(context).pop(true);
  }
}
