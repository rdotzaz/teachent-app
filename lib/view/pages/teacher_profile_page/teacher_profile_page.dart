import 'package:flutter/material.dart';
import 'package:teachent_app/controller/pages/teacher_profile_page/teacher_profile_page_controller.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';
import 'package:teachent_app/model/db_objects/teacher.dart';

class TeacherProfilePage extends StatelessWidget {
  Teacher? _teacher;
  KeyId? _studentId;
  TeacherProfilePageController? _teacherProfilePageController;
  TeacherProfilePage(
      Teacher teacher,
      KeyId studentId,
      { Key? key}) : super(key: key) {
    this._teacher = teacher;
    this._studentId = studentId;
    this._teacherProfilePageController = TeacherProfilePageController(teacher, studentId);
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
        body: CustomScrollView(slivers: [
            _appBar(),
            SliverList(
                delegate: SliverChildListDelegate([
                    _teacherDescription(),
                    _topics(),
                    _tools(),
                    _places(),
                    _teacherRate(),
                    _lessonDates()
                ])
            )
        ])
    );
  }

  Widget _appBar() {
    return SliverAppBar(
      expandedHeight: 150,
      flexibleSpace: FlexibleSpaceBar(
          title: Text(_teacherProfilePageController!.teacherName,
              style: const TextStyle(color: Colors.black)),
          background: Container(color: Colors.transparent)),
    );
  }

  Widget _teacherDescription() {
      final hasDescription = _teacherProfilePageController!.description.isNotEmpty;
      return Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
              children: [
                  const Padding(
                      padding: EdgeInsets.all(5),
                      child: Text('Few words about the teacher...')),
                  if (hasDescription)
                    Expanded(
                        child: Text(
                            _teacherProfilePageController!.description,
                            style: TextStyle(color: Colors.black))
                    ),
                  if (!hasDescription)
                    SizedBox(
                        height: 100,
                        child: Center(
                            child: Text('Teacher did not provide any description')
                        )
                    ),
              ]
          )
      );
  }

  Widget _topics() {
      return Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
              children: [
                  const Padding(
                      padding: EdgeInsets.all(5),
                      child: Text('Topics')),
                  Container(
                    height: 70,
                    padding: const EdgeInsets.all(10),
                    child: _teacherProfilePageController!.topics.isEmpty ?
                                SizedBox(
                                        height: 100,
                                        child: Center(
                                            child: Text('Teacher did not provide any topics')
                                        )
                                )
                            :
                                ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: _teacherProfilePageController!.topics.length,
                                    itemBuilder: (_, index) {
                                        return Chip(
                                            padding: const EdgeInsets.all(12.0),
                                            label: Text(_teacherProfilePageController!.topics[index].name,
                                                    style: TextStyle(fontSize: 18, color: Colors.white)),
                                            backgroundColor: Colors.blue
                                        );
                                    }
                                )
                )
              ]
          ),
      );
  }

  Widget _tools() {
      return Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
              children: [
                  const Padding(
                      padding: EdgeInsets.all(5),
                      child: Text('Tools')),
                  Container(
                    height: 70,
                    padding: const EdgeInsets.all(10),
                    child: _teacherProfilePageController!.tools.isEmpty ?
                        SizedBox(
                            height: 100,
                            child: Center(
                                child: Text('Teacher did not provide any tools')
                            )
                        )
                        :
                        ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _teacherProfilePageController!.tools.length,
                            itemBuilder: (_, index) {
                                return Chip(
                                    padding: const EdgeInsets.all(12.0),
                                    label: Text(_teacherProfilePageController!.tools[index].name,
                                            style: TextStyle(fontSize: 18, color: Colors.white)),
                                    backgroundColor: Colors.blue
                                );
                            }
      ))
                
              ]
          ),
      );
  }
  
  Widget _places() {
      return Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
              children: [
                  const Padding(
                      padding: EdgeInsets.all(5),
                      child: Text('Places')),
                  Container(
                    height: 70,
                    padding: const EdgeInsets.all(10),
                    child: _teacherProfilePageController!.places.isEmpty ?
                        SizedBox(
                            height: 100,
                            child: Center(
                                child: Text('Teacher did not provide any places')
                            )
                        )
                        :
                        ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _teacherProfilePageController!.places.length,
                            itemBuilder: (_, index) {
                                return Chip(
                                    padding: const EdgeInsets.all(12.0),
                                    label: Text(_teacherProfilePageController!.places[index].name,
                                            style: TextStyle(fontSize: 18, color: Colors.white)),
                                    backgroundColor: Colors.blue
                                );
                            }
                        ))
              ]
          ),
      );
  }
  
  Widget _teacherRate() {
      final hasRate = _teacherProfilePageController!.hasRate;
      final rate = _teacherProfilePageController!.rate;
      return Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
              children: [
                  const Padding(
                      padding: EdgeInsets.all(5),
                      child: Text('Average rate')),
                  if (hasRate)
                    Container(
                        height: 70,
                        padding: const EdgeInsets.all(10),
                        child: ListView.builder(
                            itemCount: 5,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (_, index) {
                                return Icon(
                                    Icons.star_border,
                                    color: index + 1 <= rate ? Colors.yellow : Colors.white,
                                );
                            }
                        )
                    ),
                  if (!hasRate)
                    SizedBox(
                        height: 100,
                        child: Center(
                            child: Text('Teacher do not have any rates')
                        )
                    )
              ]
          ),
      );
  }

  Widget _lessonDates() {
      return Container();
  }
}