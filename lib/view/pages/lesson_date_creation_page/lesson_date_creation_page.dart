import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachent_app/controller/pages/lesson_date_creation/lesson_date_creation_controller.dart';
import 'package:teachent_app/controller/pages/lesson_date_creation/bloc/freq_bloc.dart';
import 'package:teachent_app/controller/pages/lesson_date_creation/bloc/tool_bloc.dart';
import 'package:teachent_app/controller/pages/lesson_date_creation/bloc/place_bloc.dart';
import 'package:teachent_app/model/db_objects/teacher.dart';
import 'package:teachent_app/view/widgets/black_input_decorator.dart';
import 'package:teachent_app/view/widgets/custom_button.dart';
import 'package:teachent_app/view/widgets/header_clipper.dart';

/// Page with lesson date creation form
/// Input:
/// [teacher] - teacher for which lesson date will be created
class LessonDateCreationPage extends StatefulWidget {
  final Teacher teacher;
  const LessonDateCreationPage(this.teacher, {Key? key}) : super(key: key);

  @override
  _LessonDateCreationPageState createState() => _LessonDateCreationPageState();
}

class _LessonDateCreationPageState extends State<LessonDateCreationPage> {
  late LessonDateCreationPageController _lessonDateCreationController;

  @override
  void initState() {
    super.initState();
    _lessonDateCreationController =
        LessonDateCreationPageController(widget.teacher, refresh);
    _lessonDateCreationController.init();
  }

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final windowSize = MediaQuery.of(context).size;
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => _lessonDateCreationController.freqBloc),
          BlocProvider(create: (_) => _lessonDateCreationController.toolBloc),
          BlocProvider(create: (_) => _lessonDateCreationController.placeBloc),
        ],
        child: Scaffold(
            body: SingleChildScrollView(
                child: Column(children: [
          _lessonCreationHeader(windowSize.height),
          _form(context)
        ]))));
  }

  Widget _lessonCreationHeader(double height) {
    return Stack(
      children: [
        ClipPath(
            clipper: CreationHeaderClipper(),
            child: Container(height: height / 8, color: Colors.blue)),
        const Padding(
            padding: EdgeInsets.all(25),
            child: Text('Create new lesson date',
                style: TextStyle(fontSize: 23, color: Colors.white)))
      ],
    );
  }

  Widget _form(BuildContext context) {
    return Form(
        key: _lessonDateCreationController.formKey,
        child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(children: [
              _weekDayLabel(),
              _weekDayField(context),
              _hourTimeLabel(),
              _hourTimeField(context),
              _cycledSelecting(),
              _durationLabel(),
              _durationTextField(),
              _priceLabel(),
              _priceTextField(),
              _toolsSelecting(),
              _placesSelecting(),
              _submitButton(context)
            ])));
  }

  Widget _weekDayLabel() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.all(5.0),
      child: const Text(
        'Select start day',
        style: TextStyle(fontSize: 16, color: Colors.black),
      ),
    );
  }

  Widget _weekDayField(BuildContext context) {
    return GestureDetector(
        onTap: () => _lessonDateCreationController.enableDatePicker(context),
        child: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(5.0),
          child: Text(
            _lessonDateCreationController.date,
            style: const TextStyle(fontSize: 18, color: Colors.black),
          ),
        ));
  }

  Widget _hourTimeLabel() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.all(5.0),
      child: const Text(
        'Select time',
        style: TextStyle(fontSize: 16, color: Colors.black),
      ),
    );
  }

  Widget _hourTimeField(BuildContext context) {
    return GestureDetector(
        onTap: () => _lessonDateCreationController.enableTimePicker(context),
        child: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(5.0),
          child: Text(
            _lessonDateCreationController.time,
            style: const TextStyle(fontSize: 18, color: Colors.black),
          ),
        ));
  }

  Widget _cycledSelecting() {
    return BlocBuilder<FrequencyBloc, int>(builder: (context, _) {
      return Column(children: [
        Row(children: [
          Checkbox(
            checkColor: Colors.white,
            value: _lessonDateCreationController.isCycled,
            fillColor: MaterialStateProperty.resolveWith(
                _lessonDateCreationController.getCycledCheckBoxColor),
            onChanged: (value) =>
                context.read<FrequencyBloc>().add(ToggleCycleModeEvent()),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(5.0),
            child: const Text(
              'Lesson cycled',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          )
        ]),
        if (_lessonDateCreationController.isCycled) _cycledList()
      ]);
    });
  }

  Widget _cycledList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(2, 2))
        ],
      ),
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(5),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Padding(
            padding: EdgeInsets.all(5), child: Text('Lessons freqency')),
        Container(
            height: 50,
            padding: const EdgeInsets.all(5),
            child: BlocBuilder<FrequencyBloc, int>(builder: (_, selectedIndex) {
              return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount:
                      _lessonDateCreationController.lessonFrequencies.length,
                  itemBuilder: (context, index) {
                    final isSelected = selectedIndex == index;
                    return ActionChip(
                        padding: const EdgeInsets.all(10.0),
                        label: Text(
                            _lessonDateCreationController
                                .lessonFrequencies[index],
                            style: TextStyle(
                                fontSize: 14,
                                color:
                                    isSelected ? Colors.white : Colors.black)),
                        backgroundColor: isSelected ? Colors.blue : Colors.grey,
                        onPressed: () => context
                            .read<FrequencyBloc>()
                            .add(ToggleFreqencyEvent(index)));
                  });
            }))
      ]),
    );
  }

  Widget _durationLabel() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.all(5.0),
      child: const Text(
        'Specify lesson duration',
        style: TextStyle(fontSize: 16, color: Colors.black),
      ),
    );
  }

  Widget _durationTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        keyboardType: TextInputType.number,
        validator: (duration) =>
            _lessonDateCreationController.validateDuration(duration),
        onChanged: (duration) =>
            _lessonDateCreationController.setDuration(duration),
        decoration: blackInputDecorator('Duration'),
      ),
    );
  }

  Widget _priceLabel() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.all(5.0),
      child: const Text(
        'Specify price for single lesson',
        style: TextStyle(fontSize: 16, color: Colors.black),
      ),
    );
  }

  Widget _priceTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        keyboardType: TextInputType.number,
        validator: (price) =>
            _lessonDateCreationController.validatePrice(price),
        onChanged: (price) => _lessonDateCreationController.setPrice(price),
        decoration: blackInputDecorator('Price'),
      ),
    );
  }

  Widget _toolsSelecting() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(2, 2))
        ],
      ),
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(5),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Padding(padding: EdgeInsets.all(5), child: Text('Tools')),
        Container(
            height: 50,
            padding: const EdgeInsets.all(5),
            child: BlocBuilder<ToolBloc, List<bool>>(builder: (_, indexes) {
              return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _lessonDateCreationController.tools.length,
                  itemBuilder: (context, index) {
                    final isMarked = indexes[index];
                    final tool = _lessonDateCreationController.tools[index];
                    return ActionChip(
                        padding: const EdgeInsets.all(10.0),
                        label: Text(tool.name,
                            style: TextStyle(
                                fontSize: 14,
                                color: isMarked ? Colors.white : Colors.black)),
                        backgroundColor: isMarked ? Colors.blue : Colors.grey,
                        onPressed: () => context
                            .read<ToolBloc>()
                            .add(ToggleToolEvent(index)));
                  });
            }))
      ]),
    );
  }

  Widget _placesSelecting() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(2, 2))
        ],
      ),
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(5),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Padding(padding: EdgeInsets.all(5), child: Text('Places')),
        Container(
            height: 50,
            padding: const EdgeInsets.all(5),
            child: BlocBuilder<PlaceBloc, List<bool>>(builder: (_, indexes) {
              return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _lessonDateCreationController.places.length,
                  itemBuilder: (context, index) {
                    final isMarked = indexes[index];
                    final place = _lessonDateCreationController.places[index];
                    return ActionChip(
                        padding: const EdgeInsets.all(10.0),
                        label: Text(place.name,
                            style: TextStyle(
                                fontSize: 14,
                                color: isMarked ? Colors.white : Colors.black)),
                        backgroundColor: isMarked ? Colors.blue : Colors.grey,
                        onPressed: () => context
                            .read<PlaceBloc>()
                            .add(TogglePlaceEvent(index)));
                  });
            }))
      ]),
    );
  }

  Widget _submitButton(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(25),
        child: CustomButton(
            text: 'Create new date',
            fontSize: 18,
            buttonColor: Colors.blue,
            onPressed: () =>
                _lessonDateCreationController.validateForm(context)));
  }
}
