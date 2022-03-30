import 'package:flutter/material.dart';
import 'package:teachent_app/controller/pages/student_creation/student_creation_page_controller.dart';
import 'package:teachent_app/view/widgets/black_input_decorator.dart';

Widget nameStudentSubPage(StudentCreationPageController studentController) {
  return Form(
    key: studentController.formKey,
    child: Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(children: [
        nameLabel(studentController),
        nameTextField(studentController)
      ]),
    ),
  );
}

Container nameLabel(StudentCreationPageController studentController) {
  return Container(
    alignment: Alignment.centerLeft,
    padding: const EdgeInsets.all(5.0),
    child: const Text(
      'Name',
      style: TextStyle(fontSize: 18, color: Colors.black),
    ),
  );
}

Padding nameTextField(StudentCreationPageController studentController) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10.0),
    child: TextFormField(
      keyboardType: TextInputType.text,
      validator: (name) => studentController.validateName(name),
      onChanged: (name) => studentController.setName(name),
      decoration: blackInputDecorator('Name'),
    ),
  );
}
