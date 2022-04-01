import 'package:flutter/material.dart';
import 'package:teachent_app/controller/pages/teacher_home_page/teacher_home_page_controller.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';

class TeacherHomePage extends StatefulWidget {
  final KeyId userId;
  const TeacherHomePage({Key? key, required this.userId}) : super(key: key);

  @override
  State<TeacherHomePage> createState() => _TeacherHomePageState();
}

class _TeacherHomePageState extends State<TeacherHomePage> {
  late TeacherHomePageController _teacherHomePageController;

  @override
  void initState() {
    super.initState();
    _teacherHomePageController = TeacherHomePageController(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: _teacherHomePageController.init(),
            builder: (_, snapshot) {
              if (snapshot.hasError) {
                return Container(
                  color: Colors.red,
                  child: Text(snapshot.error.toString()),
                );
              } else if (snapshot.hasData) {
                return CustomScrollView(slivers: [
                  SliverAppBar(
                    expandedHeight: 120,
                    flexibleSpace: FlexibleSpaceBar(
                        title: Text(
                            'Hi, ${_teacherHomePageController.teacherName}'),
                        background: Container(color: Colors.grey)),
                  ),
                  SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                    return SizedBox(height: 100, child: Text('$index'));
                  }, childCount: 10))
                ]);
              } else {
                return Container();
              }
            }));
  }
}
