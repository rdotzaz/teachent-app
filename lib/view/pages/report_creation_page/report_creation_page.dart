import 'package:flutter/material.dart';
import 'package:teachent_app/controller/pages/report_creation/report_creation_page_controller.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';
import 'package:teachent_app/view/widgets/black_input_decorator.dart';
import 'package:teachent_app/view/widgets/custom_button.dart';
import 'package:teachent_app/view/widgets/label.dart';

class ReportCreationPage extends StatefulWidget {
  final List<KeyId> lessonDateIds;
  ReportCreationPage({ Key? key, required this.lessonDateIds}) : super(key: key);

  @override
  _ReportCreationPageState createState() => _ReportCreationPageState();
}

class _ReportCreationPageState extends State<ReportCreationPage> {
  late ReportCreationPageController reportController;

  @override
  void initState() {
    super.initState();
    reportController = ReportCreationPageController(refresh, widget.lessonDateIds);
  }

  @override
  void dispose() {
    reportController.dispose();
    super.dispose();
  }

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create report')),
      body: Column(
          children: [
            reportController.hasLessons ? _selectLessonField() : Label(text: 'You do not have lessons to report'),
            if (reportController.isLessonSelected)
              _reportForm(context)
          ]
        )
    );
  }

  Widget _selectLessonField() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: DropdownButton<String>(
        value: reportController.initialLessonValue,
        icon: const Icon(Icons.arrow_downward),
        onChanged: (value) => reportController.selectLessonValue(value),
        items: reportController.lessonItems.map((value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value)
          );
        }).toList()
      )
    );
  }

  Widget _reportForm(BuildContext context) {
    return Form(
      key: reportController.formKey,
      child: Column(
        children: [
          Padding(
              padding: const EdgeInsets.all(15),
              child: TextFormField(
                keyboardType: TextInputType.text,
                validator: (title) => reportController.validateTitle(title), 
                onChanged: (title) => reportController.setTitle(title),
                decoration: blackInputDecorator('Lesson title')
              ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: TextFormField(
                keyboardType: TextInputType.text,
                onChanged: (description) => reportController.setDescription(description),
                decoration: blackInputDecorator('Something about lesson'),
                expands: true,
              ),
          )),
          CustomButton(
            text: 'Save',
            fontSize: 18,
            onPressed: () => reportController.saveReport(context),
            buttonColor: Colors.blue
          )
        ]
      )
    );
  }
}
