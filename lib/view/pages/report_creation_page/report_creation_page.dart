import 'package:flutter/material.dart';
import 'package:teachent_app/controller/pages/report_creation/report_creation_page_controller.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';
import 'package:teachent_app/view/widgets/black_input_decorator.dart';
import 'package:teachent_app/view/widgets/custom_button.dart';
import 'package:teachent_app/view/widgets/label.dart';

class ReportCreationPage extends StatefulWidget {
  final List<KeyId> lessonDateIds;
  ReportCreationPage({Key? key, required this.lessonDateIds}) : super(key: key);

  @override
  _ReportCreationPageState createState() => _ReportCreationPageState();
}

class _ReportCreationPageState extends State<ReportCreationPage> {
  late ReportCreationPageController reportController;

  @override
  void initState() {
    super.initState();
    reportController =
        ReportCreationPageController(refresh, widget.lessonDateIds);
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
    return FutureBuilder(
        future: reportController.init(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
                appBar: AppBar(title: Text('Create report')),
                body: Column(
                  children: [
                  reportController.hasLessons
                      ? _selectLessonField()
                      : _emptyLesson(),
                  if (reportController.isLessonSelected) _reportForm(context)
                ]));
          }
          return _errorWidget(snapshot.error.toString());
        });
  }

  Widget _emptyLesson() {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: const Offset(2, 2))
            ]),
        margin: const EdgeInsets.all(15),
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
          Padding(
              padding: const EdgeInsets.all(25),
              child: Icon(Icons.my_library_books, size: 40)),
          Label(text: 'You do not have lessons to report')
        ]));
  }

  Widget _selectLessonField() {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: DropdownButton<String>(
            value: reportController.initialLessonValue,
            icon: const Icon(Icons.arrow_downward),
            onChanged: (value) => reportController.selectLessonValue(value),
            items: reportController.lessonItems.map((value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList()));
  }

  Widget _reportForm(BuildContext context) {
    return Form(
        key: reportController.formKey,
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: TextFormField(
                keyboardType: TextInputType.text,
                validator: (title) => reportController.validateTitle(title),
                onChanged: (title) => reportController.setTitle(title),
                decoration: blackInputDecorator('Lesson title')),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: TextFormField(
              keyboardType: TextInputType.text,
              onChanged: (description) =>
                  reportController.setDescription(description),
              decoration: blackInputDecorator('Something about lesson'),
            ),
          ),
          CustomButton(
              text: 'Save',
              fontSize: 18,
              onPressed: () => reportController.saveReport(context),
              buttonColor: Colors.blue)
        ]));
  }

  Widget _errorWidget(String errorMessage) {
    return Container(
      color: Colors.red,
      child: Column(children: [
        const Padding(
            padding: EdgeInsets.all(30),
            child: Icon(Icons.error, color: Colors.white)),
        Text(errorMessage),
      ]),
    );
  }
}
