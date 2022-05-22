import 'package:flutter/material.dart';
import 'package:teachent_app/model/db_objects/student.dart';
import 'package:teachent_app/model/db_objects/teacher.dart';

/// Card widger for found teachers
/// Contains basic infomrations about teacher like
/// name, topics, tools, places
/// Input:
/// [teacher] - teacher object
/// [onPressed] - action after clicking this card by user
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
            child: Column(children: [
              Row(
                children: [
                  const Icon(Icons.person, size: 45),
                  Expanded(
                      child: Text(teacher.name,
                          style: const TextStyle(color: Colors.black))),
                ],
              ),
              if (teacher.topics.isNotEmpty) topicTags(),
              if (teacher.tools.isNotEmpty) toolTags(),
              if (teacher.places.isNotEmpty) placeTags(),
            ])));
  }

  Widget topicTags() {
    return SizedBox(
        height: 30,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: teacher.topics.length,
            itemBuilder: (context, index) {
              return Container(
                  margin: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.all(4.0),
                  child: Text(teacher.topics[index].name,
                      style: const TextStyle(color: Colors.white)));
            }));
  }

  Widget toolTags() {
    return SizedBox(
        height: 30,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: teacher.tools.length,
            itemBuilder: (context, index) {
              return Container(
                  margin: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.all(4.0),
                  child: Text(teacher.tools[index].name,
                      style: const TextStyle(color: Colors.white)));
            }));
  }

  Widget placeTags() {
    return SizedBox(
        height: 30,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: teacher.places.length,
            itemBuilder: (context, index) {
              return Container(
                  margin: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.all(4.0),
                  child: Text(teacher.places[index].name,
                      style: const TextStyle(color: Colors.white)));
            }));
  }
}

/// Card widger for found students
/// Contains basic infomrations about student like
/// name, education level
/// Input:
/// [student] - student object
/// [onPressed] - action after clicking this card by user
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
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: [
                  const Icon(Icons.person, size: 45),
                  Expanded(
                      child: Text(student.name,
                          style: const TextStyle(color: Colors.black))),
                ],
              ),
              Container(
                  margin: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.all(4.0),
                  child: Text(student.educationLevel.name,
                      style: const TextStyle(color: Colors.white)))
            ])));
  }
}
