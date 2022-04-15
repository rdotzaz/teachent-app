import 'package:flutter/material.dart';
import 'package:teachent_app/controller/pages/teacher_profile_page/teacher_profile_page_controller.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';
import 'package:teachent_app/model/db_objects/teacher.dart';

class TeacherProfilePage extends StatelessWidget {
  TeacherProfilePageController? _teacherProfilePageController;
  TeacherProfilePage(Teacher teacher, KeyId studentId, {Key? key})
      : super(key: key) {
    _teacherProfilePageController =
        TeacherProfilePageController(teacher, studentId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(slivers: [
      _appBar(),
      SliverList(
          delegate: SliverChildListDelegate([
        _teacherRate(),
        _lessonDates(),
        _teacherDescription(),
        _topics(),
        _tools(),
        _places()
      ]))
    ]));
  }

  Widget _appBar() {
    return SliverAppBar(
      expandedHeight: 150,
      flexibleSpace: FlexibleSpaceBar(
          title: Text(_teacherProfilePageController!.teacherName,
              style: const TextStyle(color: Colors.white)),
          background: Container(color: Colors.transparent)),
    );
  }

  Widget _teacherDescription() {
    final hasDescription =
        _teacherProfilePageController!.description.isNotEmpty;
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
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Padding(
              padding: EdgeInsets.all(5),
              child: Text('Few words about the teacher...')),
          if (hasDescription)
            Expanded(
                child: Text(_teacherProfilePageController!.description,
                    style: const TextStyle(color: Colors.black))),
          if (!hasDescription)
            const SizedBox(
                height: 100,
                child: Center(
                    child: Text('Teacher did not provide any description'))),
        ]));
  }

  Widget _topics() {
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
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Padding(padding: EdgeInsets.all(5), child: Text('Topics')),
        Container(
            height: 70,
            padding: const EdgeInsets.all(5),
            child: _teacherProfilePageController!.topics.isEmpty
                ? const SizedBox(
                    height: 100,
                    child: Center(
                        child: Text('Teacher did not provide any topics')))
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _teacherProfilePageController!.topics.length,
                    itemBuilder: (_, index) {
                      return Chip(
                          padding: const EdgeInsets.all(12.0),
                          label: Text(
                              _teacherProfilePageController!.topics[index].name,
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.white)),
                          backgroundColor: Colors.blue);
                    }))
      ]),
    );
  }

  Widget _tools() {
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
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Padding(padding: EdgeInsets.all(5), child: Text('Tools')),
        Container(
            height: 70,
            padding: const EdgeInsets.all(5),
            child: _teacherProfilePageController!.tools.isEmpty
                ? const SizedBox(
                    height: 100,
                    child: Center(
                        child: Text('Teacher did not provide any tools')))
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _teacherProfilePageController!.tools.length,
                    itemBuilder: (_, index) {
                      return Chip(
                          padding: const EdgeInsets.all(12.0),
                          label: Text(
                              _teacherProfilePageController!.tools[index].name,
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.white)),
                          backgroundColor: Colors.blue);
                    }))
      ]),
    );
  }

  Widget _places() {
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
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Padding(padding: EdgeInsets.all(5), child: Text('Places')),
        Container(
            height: 70,
            padding: const EdgeInsets.all(5),
            child: _teacherProfilePageController!.places.isEmpty
                ? const SizedBox(
                    height: 100,
                    child: Center(
                        child: Text('Teacher did not provide any places')))
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _teacherProfilePageController!.places.length,
                    itemBuilder: (_, index) {
                      return Chip(
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          label: Text(
                              _teacherProfilePageController!.places[index].name,
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.white)),
                          backgroundColor: Colors.blue);
                    }))
      ]),
    );
  }

  Widget _teacherRate() {
    final hasRate = _teacherProfilePageController!.hasRate;
    final rate = _teacherProfilePageController!.rate;
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
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(15),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Padding(padding: EdgeInsets.all(5), child: Text('Average rate')),
        if (hasRate)
          Container(
              height: 70,
              padding: const EdgeInsets.all(10),
              child: ListView.builder(
                  itemCount: 5,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (_, index) {
                    return Icon(
                      Icons.star,
                      size: 40,
                      color: index + 1 <= rate ? Colors.yellow : Colors.white,
                    );
                  })),
        if (!hasRate)
          const SizedBox(
              height: 100,
              child: Center(child: Text('Teacher do not have any rates')))
      ]),
    );
  }

  Widget _lessonDates() {
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
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(10),
        child: FutureBuilder(
            future: _teacherProfilePageController!.initDates(),
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.connectionState == ConnectionState.done) {
                return _lessonDateListBuilder();
              }
              return Text(snapshot.error.toString());
            }));
  }

  Widget _lessonDateListBuilder() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Padding(
          padding: EdgeInsets.all(5), child: Text('Available lesson dates')),
      Container(
          height: 70,
          padding: const EdgeInsets.all(5),
          child: _teacherProfilePageController!.lessonDates.isEmpty
              ? const SizedBox(
                  height: 100,
                  child:
                      Center(child: Text('Teacher did not provide any dates')))
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: _teacherProfilePageController!.lessonDates.length,
                  itemBuilder: (context, index) {
                    final lessonDate =
                        _teacherProfilePageController!.lessonDates[index];
                    return Container(
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(lessonDate.weekday,
                                  style: const TextStyle(
                                      fontSize: 18, color: Colors.white)),
                              Text(lessonDate.hourTime,
                                  style: const TextStyle(
                                      fontSize: 20, color: Colors.white)),
                              const SizedBox(height: 20),
                              Text('Price: ${lessonDate.price}',
                                  style: const TextStyle(
                                      fontSize: 20, color: Colors.white)),
                            ]));
                  }))
    ]);
  }
}
