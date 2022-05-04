import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachent_app/common/enums.dart';
import 'package:teachent_app/controller/controller.dart';
import 'package:teachent_app/controller/pages/search_page/bloc/items_bloc.dart';
import 'package:teachent_app/controller/pages/search_page/bloc/person_type_bloc.dart';
import 'package:teachent_app/controller/pages/search_page/teacher_search_page_controller.dart';

class TeacherSearchBarWidget extends StatelessWidget {
  final TeacherSearchPageController controller;
  const TeacherSearchBarWidget({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonTypeBloc, PersonType>(
        builder: (context, personType) {
      return Stack(alignment: AlignmentDirectional.centerStart, children: [
        heroSearchBar(),
        Container(
            color: Colors.white,
            margin: const EdgeInsets.fromLTRB(70, 0, 40, 5),
            child: TextField(
                controller: controller.searchController,
                onSubmitted: (value) => context
                    .read<ItemsBloc>()
                    .add(RefreshItemsEvent(value, personType))))
      ]);
    });
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
                Text('Search people',
                    style: TextStyle(fontSize: 18, color: Colors.grey))
              ],
            ),
          ),
        ));
  }
}
