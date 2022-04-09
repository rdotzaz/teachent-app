import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachent_app/controller/pages/search_page/bloc/items_bloc.dart';
import 'package:teachent_app/controller/pages/search_page/bloc/topic_bloc.dart';
import 'package:teachent_app/controller/pages/search_page/bloc/tool_bloc.dart';
import 'package:teachent_app/controller/pages/search_page/bloc/place_bloc.dart';
import 'package:teachent_app/controller/pages/search_page/student_search_page_controller.dart';

class StudentSearchBarWidget extends StatelessWidget {
  final StudentSearchPageController controller;
  const StudentSearchBarWidget({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: AlignmentDirectional.centerStart, children: [
      heroSearchBar(),
      Container(
          color: Colors.white,
          margin: const EdgeInsets.fromLTRB(70, 0, 40, 5),
          child: BlocBuilder<TopicSelectBloc, List<String>>(
              builder: (_, topicNames) {
            return BlocBuilder<ToolSelectBloc, List<String>>(
                builder: (_, toolNames) {
              return BlocBuilder<PlaceSelectBloc, List<String>>(
                  builder: (_, placeNames) {
                return TextField(
                    controller: controller.searchController,
                    onSubmitted: (value) => context.read<ItemsBloc>().add(
                        RefreshTeacherItemsEvent(
                            value, topicNames, toolNames, placeNames)));
              });
            });
          }))
    ]);
  }

  Widget heroSearchBar() {
    return Hero(
        tag: 'search',
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
          margin: const EdgeInsets.all(15),
          padding: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: const [
                Icon(Icons.search, color: Colors.grey, size: 25),
                SizedBox(width: 20),
                Text('Search teachers...',
                    style: TextStyle(fontSize: 18, color: Colors.grey))
              ],
            ),
          ),
        ));
  }
}
