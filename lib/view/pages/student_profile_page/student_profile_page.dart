import 'package:flutter/material.dart';
import 'package:teachent_app/controller/pages/student_profile_page/student_profile_page_controller.dart';
import 'package:teachent_app/model/db_objects/student.dart';
import 'package:teachent_app/view/widgets/label.dart';

/// Page with basic information about [student]
// ignore: must_be_immutable
class StudentProfilePage extends StatelessWidget {
  StudentProfilePageController? _studentProfilePageController;
  StudentProfilePage(Student student, {Key? key}) : super(key: key) {
    _studentProfilePageController = StudentProfilePageController(student);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(_studentProfilePageController!.name)),
        body: Column(children: [_educationLevel(), _reviews()]));
  }

  Widget _educationLevel() {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      const Label(text: 'Education level:'),
      Label(text: _studentProfilePageController!.educationLevel)
    ]);
  }

  Widget _reviews() {
    return Container();
  }
}
