import 'package:flutter/material.dart';
import 'package:teachent_app/controller/pages/lesson_date_creation/lesson_date_creation_controller.dart';
import 'package:teachent_app/model/db_objects/teacher.dart';
import 'package:teachent_app/view/widgets/black_input_decorator.dart';
import 'package:teachent_app/view/widgets/custom_button.dart';
import 'package:teachent_app/view/widgets/header_clipper.dart';

class LessonDateCreationPage extends StatefulWidget {
  final Teacher teacher;
  const LessonDateCreationPage(this.teacher, { Key? key }) : super(key: key);

  @override
  _LessonDateCreationPageState createState() => _LessonDateCreationPageState();
}

class _LessonDateCreationPageState extends State<LessonDateCreationPage> {
  late LessonDateCreationPageController _lessonDateCreationController;

  @override
  void initState() {
      super.initState();
      _lessonDateCreationController = LessonDateCreationPageController(widget.teacher, refresh);
      _lessonDateCreationController.init();
  }

  void refresh() {
      setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final windowSize = MediaQuery.of(context).size;
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
            children: [
                _lessonCreationHeader(windowSize.height),
                _form(context)
            ]
        )
    ));
  }

  Widget _lessonCreationHeader(double height) {
      return Stack(
        children: [
            ClipPath(
                clipper: CreationHeaderClipper(),
                child: Container(height: height / 8, color: Colors.blue)),
            Padding(
                padding: const EdgeInsets.all(25),
                child: Text('Create new lesson date',
                    style: const TextStyle(fontSize: 23, color: Colors.white)))
        ],
    );
  }

  Widget _form(BuildContext context) {
      return Form(
          key: _lessonDateCreationController.formKey,
          child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                    children: [
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
                    ]
                )
          )
      );
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
            )
      );
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
                    _lessonDateCreationController.time(context),
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                ),
            )
      );
  }

  Widget _cycledSelecting() {
      return Column(
          children: [
              Row(
                children: [
                    Checkbox(
                        checkColor: Colors.white,
                        value: _lessonDateCreationController.isCycled,
                        fillColor: MaterialStateProperty.resolveWith(_lessonDateCreationController.getCycledCheckBoxColor),
                        onChanged: (value) => _lessonDateCreationController.toggleCycleCheck(value),

                    ),
                    Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.all(5.0),
                        child: const Text(
                            'Lesson cycled',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                    )
                ]
              ),
              if (_lessonDateCreationController.isCycled)
                _cycledList()
          ]
      );
      return Row(
          children: [
              Checkbox(
                  checkColor: Colors.white,
                  value: _lessonDateCreationController.isCycled,
                  fillColor: MaterialStateProperty.resolveWith(_lessonDateCreationController.getCycledCheckBoxColor),
                  onChanged: (value) => _lessonDateCreationController.toggleCycleCheck(value),

              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(5.0),
                child: const Text(
                    'Lesson cycled',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              )
          ]
      );
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
        const Padding(padding: EdgeInsets.all(5), child: Text('Lessons freqency')),
        Container(
            height: 50,
            padding: const EdgeInsets.all(5),
            child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _lessonDateCreationController.lessonFrequencies.length,
                    itemBuilder: (_, index) {
                      final isSelected = _lessonDateCreationController.isFreqSelected(index);
                      return ActionChip(
                          padding: const EdgeInsets.all(10.0),
                          label: Text(
                              _lessonDateCreationController.lessonFrequencies[index],
                              style: TextStyle(
                                  fontSize: 14, color: isSelected ? Colors.white : Colors.black)),
                          backgroundColor: isSelected ? Colors.blue : Colors.grey,
                          onPressed: () => _lessonDateCreationController.toggleFreq(index));
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
            validator: (duration) => _lessonDateCreationController.validateDuration(duration),
            onChanged: (duration) => _lessonDateCreationController.setDuration(duration),
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
            validator: (price) => _lessonDateCreationController.validatePrice(price),
            onChanged: (price) => _lessonDateCreationController.setPrice(price),
            decoration: blackInputDecorator('Price'),
        ),
    );
  }

  Widget _toolsLabel() {
      return Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(5.0),
        child: const Text(
            'Tools',
            style: TextStyle(fontSize: 16, color: Colors.black),
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
            child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _lessonDateCreationController.tools.length,
                    itemBuilder: (_, index) {
                        final tool = _lessonDateCreationController.tools[index];
                      return ActionChip(
                          padding: const EdgeInsets.all(10.0),
                          label: Text(
                              tool.name,
                              style: TextStyle(
                                  fontSize: 14, color: tool.marked ? Colors.white : Colors.black)),
                          backgroundColor: tool.marked ? Colors.blue : Colors.grey,
                          onPressed: () => _lessonDateCreationController.toggleTool(index));
                    }))
      ]),
    );
  }

  Widget _placesLabel() {
      return Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(5.0),
        child: const Text(
            'Places',
            style: TextStyle(fontSize: 16, color: Colors.black),
        ),
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
            child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _lessonDateCreationController.places.length,
                    itemBuilder: (_, index) {
                      final place = _lessonDateCreationController.places[index];
                      return ActionChip(
                          padding: const EdgeInsets.all(10.0),
                          label: Text(
                              place.name,
                              style: TextStyle(
                                  fontSize: 14, color: place.marked ? Colors.white : Colors.black)),
                          backgroundColor: place.marked ? Colors.blue : Colors.grey,
                          onPressed: () => _lessonDateCreationController.togglePlace(index));
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
              onPressed: () => _lessonDateCreationController.validateForm(context)
          )
      );
  }
}