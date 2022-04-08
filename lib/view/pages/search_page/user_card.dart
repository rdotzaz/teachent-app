import 'package:flutter/material.dart';
import 'package:teachent_app/model/db_objects/student.dart';
import 'package:teachent_app/model/db_objects/teacher.dart';

class TeacherCardWidget extends StatelessWidget {
  final Teacher teacher;
  final void Function() onPressed;
  const TeacherCardWidget(
      {Key? key, required this.teacher, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: const Offset(2, 2))
            ],
          ),
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const Icon(Icons.person, size: 45),
              Expanded(
                  child: Text(teacher.name,
                      style: const TextStyle(color: Colors.black))),
            ],
          )),
    );
  }
}

class StudentCardWidget extends StatelessWidget {
  final Student student;
  final void Function() onPressed;
  const StudentCardWidget(
      {Key? key, required this.student, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onPressed,
        child: Container(
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: const Offset(2, 2))
              ],
            ),
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Icon(Icons.person, size: 45),
                Expanded(
                    child: Text(student.name,
                        style: const TextStyle(color: Colors.black))),
              ],
            )));
  }
}
