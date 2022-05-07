import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachent_app/controller/pages/search_page/bloc/items_bloc.dart';
import 'package:teachent_app/controller/pages/search_page/bloc/topic_bloc.dart';
import 'package:teachent_app/controller/pages/search_page/bloc/tool_bloc.dart';
import 'package:teachent_app/controller/pages/search_page/bloc/place_bloc.dart';
import 'package:teachent_app/controller/pages/search_page/student_search_page_controller.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';

import 'student_search_bar_widget.dart';
import 'user_card.dart';

class StudentSearchPage extends StatefulWidget {
  final KeyId studentId;
  const StudentSearchPage(this.studentId, {Key? key}) : super(key: key);

  @override
  State<StudentSearchPage> createState() => _StudentSearchPageState();
}

class _StudentSearchPageState extends State<StudentSearchPage> {
  late StudentSearchPageController _searchPageController;

  @override
  void initState() {
    super.initState();
    _searchPageController = StudentSearchPageController(widget.studentId);
    _searchPageController.init();
  }

  @override
  void dispose() {
    _searchPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => ItemsBloc(_searchPageController)),
          BlocProvider(create: (_) => TopicSelectBloc(_searchPageController)),
          BlocProvider(create: (_) => ToolSelectBloc(_searchPageController)),
          BlocProvider(create: (_) => PlaceSelectBloc(_searchPageController)),
        ],
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
                iconTheme: const IconThemeData(color: Colors.black),
                title:
                    const Text('Search', style: TextStyle(color: Colors.black)),
                elevation: 0,
                backgroundColor: Colors.transparent),
            body: Column(
              children: [
                StudentSearchBarWidget(controller: _searchPageController),
                filtersWidget(),
                foundListWidget()
              ],
            )));
  }

  Widget filtersWidget() {
    return Column(children: [
      const Padding(
          padding: EdgeInsets.all(15),
          child: Text('Filters',
              style: TextStyle(fontSize: 18, color: Colors.black))),
      topicChipActions(),
      toolChipActions(),
      placeChipActions()
    ]);
  }

  Widget topicChipActions() {
    return Container(
        height: 70,
        padding: const EdgeInsets.all(5),
        child: FutureBuilder(
            future: _searchPageController.initAllTopics(),
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.connectionState == ConnectionState.done) {
                return topicListBuilder();
              }
              return Text(snapshot.error.toString());
            }));
  }

  Widget topicListBuilder() {
    return BlocBuilder<TopicSelectBloc, List<String>>(builder: (_, topicNames) {
      return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _searchPageController.topics.length,
          itemBuilder: (context, index) {
            final isMarked =
                topicNames.contains(_searchPageController.topics[index].name);
            return Container(
                margin: const EdgeInsets.all(8.0),
                child: ActionChip(
                    padding: const EdgeInsets.all(12.0),
                    label: Text(_searchPageController.topics[index].name,
                        style: TextStyle(
                            fontSize: 14,
                            color: isMarked ? Colors.white : Colors.black)),
                    backgroundColor: isMarked ? Colors.red : Colors.grey,
                    onPressed: () {
                      context
                          .read<TopicSelectBloc>()
                          .add(ToggleTopicEvent(index));
                    }));
          });
    });
  }

  Widget toolChipActions() {
    return Container(
        height: 70,
        padding: const EdgeInsets.all(5),
        child: FutureBuilder(
            future: _searchPageController.initAllTools(),
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.connectionState == ConnectionState.done) {
                return toolListBuilder();
              }
              return Text(snapshot.error.toString());
            }));
  }

  Widget toolListBuilder() {
    return BlocBuilder<ToolSelectBloc, List<String>>(builder: (_, toolNames) {
      return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _searchPageController.tools.length,
          itemBuilder: (context, index) {
            final isMarked =
                toolNames.contains(_searchPageController.tools[index].name);
            return Container(
                margin: const EdgeInsets.all(8.0),
                child: ActionChip(
                    padding: const EdgeInsets.all(12.0),
                    label: Text(_searchPageController.tools[index].name,
                        style: TextStyle(
                            fontSize: 14,
                            color: isMarked ? Colors.white : Colors.black)),
                    backgroundColor: isMarked ? Colors.red : Colors.grey,
                    onPressed: () {
                      context
                          .read<ToolSelectBloc>()
                          .add(ToggleToolEvent(index));
                    }));
          });
    });
  }

  Widget placeChipActions() {
    return Container(
        height: 70,
        padding: const EdgeInsets.all(5),
        child: FutureBuilder(
            future: _searchPageController.initAllPlaces(),
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.connectionState == ConnectionState.done) {
                return placeListBuilder();
              }
              return Text(snapshot.error.toString());
            }));
  }

  Widget placeListBuilder() {
    return BlocBuilder<PlaceSelectBloc, List<String>>(builder: (_, placeNames) {
      return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _searchPageController.places.length,
          itemBuilder: (context, index) {
            final isMarked =
                placeNames.contains(_searchPageController.places[index].name);
            return Container(
                margin: const EdgeInsets.all(8.0),
                child: ActionChip(
                    padding: const EdgeInsets.all(12.0),
                    label: Text(_searchPageController.places[index].name,
                        style: TextStyle(
                            fontSize: 14,
                            color: isMarked ? Colors.white : Colors.black)),
                    backgroundColor: isMarked ? Colors.red : Colors.grey,
                    onPressed: () {
                      context
                          .read<PlaceSelectBloc>()
                          .add(TogglePlaceEvent(index));
                    }));
          });
    });
  }

  Widget foundListWidget() {
    return BlocBuilder<ItemsBloc, String>(builder: (context, phrase) {
      if (phrase.isEmpty) {
        return const Center(child: Text('No items found'));
      }
      return SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
                padding: EdgeInsets.all(8.0), child: Text('Teachers')),
            ListView.builder(
                itemCount: _searchPageController.teachers.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return TeacherCardWidget(
                      teacher: _searchPageController.teachers[index],
                      onPressed: () => _searchPageController.goToProfilePage(
                          context, index));
                }),
          ],
        ),
      );
    });
  }
}
