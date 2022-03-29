import 'package:flutter/material.dart';
import 'package:teachent_app/controller/pages/teacher_creation/teacher_creation_page_controller.dart';
import 'package:teachent_app/view/widgets/black_input_decorator.dart';

Widget nameSubPage(TeacherCreationPageController teacherController) {
  return Form(
    key: teacherController.nameSubPageKey,
    child: Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(children: [
        nameLabel(teacherController),
        nameTextField(teacherController),
        descriptionLabel(teacherController),
        descriptionTextField(teacherController)
      ]),
    ),
  );
}

Container nameLabel(TeacherCreationPageController teacherController) {
  return Container(
    alignment: Alignment.centerLeft,
    padding: const EdgeInsets.all(5.0),
    child: const Text(
      'Name',
      style: TextStyle(fontSize: 18, color: Colors.black),
    ),
  );
}

Padding nameTextField(TeacherCreationPageController teacherController) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10.0),
    child: TextFormField(
      keyboardType: TextInputType.text,
      validator: (name) => teacherController.validateName(name),
      onChanged: (name) => teacherController.setName(name),
      decoration: blackInputDecorator('Name'),
    ),
  );
}

Container descriptionLabel(TeacherCreationPageController teacherController) {
  return Container(
    alignment: Alignment.centerLeft,
    padding: const EdgeInsets.all(5.0),
    child: const Text(
      'Few words about you...',
      style: TextStyle(fontSize: 18, color: Colors.black),
    ),
  );
}

Padding descriptionTextField(TeacherCreationPageController teacherController) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10.0),
    child: TextFormField(
      minLines: 3,
      maxLines: 4,
      keyboardType: TextInputType.text,
      validator: (description) => null,
      onChanged: (description) => teacherController.setDescription(description),
      decoration: blackInputDecorator('Description'),
    ),
  );
}
