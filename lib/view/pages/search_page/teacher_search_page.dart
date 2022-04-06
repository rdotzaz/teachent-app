import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachent_app/controller/pages/search_page/bloc/items_bloc.dart';
import 'package:teachent_app/controller/pages/search_page/teacher_search_page_controller.dart';

class TeacherSearchPage extends StatelessWidget {
  TeacherSearchPage({Key? key}) : super(key: key);

  final controller = TeacherSearchPageController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ItemsBloc(controller),
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: Column(
            children: [
              SearchBarWidget(controller: controller),
              filtersWidget(),
              foundListWidget()
            ],
          )),
    );
  }

  Widget filtersWidget() {
    return Column(
      children: [
        const Padding(
            padding: EdgeInsets.all(15),
            child: Text('Filters',
                style: TextStyle(fontSize: 18, color: Colors.black))),
        Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              ActionChip(
                padding: const EdgeInsets.all(12.0),
                label: const Text('All',
                    style: TextStyle(fontSize: 14, color: Colors.white)),
                backgroundColor: Colors.blue,
                shadowColor: Colors.blue[200],
                elevation: 2,
                onPressed: () {},
              ),
              const SizedBox(width: 15),
              ActionChip(
                padding: const EdgeInsets.all(12.0),
                label: const Text('Teachers',
                    style: TextStyle(fontSize: 14, color: Colors.white)),
                backgroundColor: Colors.blue,
                shadowColor: Colors.blue[200],
                elevation: 2,
                onPressed: () {},
              ),
              const SizedBox(width: 15),
              ActionChip(
                padding: const EdgeInsets.all(12.0),
                label: const Text('Students',
                    style: TextStyle(fontSize: 14, color: Colors.white)),
                backgroundColor: Colors.blue,
                shadowColor: Colors.blue[200],
                elevation: 2,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ],
    );
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
                itemCount: controller.teachers.length,
                shrinkWrap: true,
                itemBuilder: (_, index) {
                  return Container(
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
                      child: Text(controller.teachers[index].name,
                          style: const TextStyle(color: Colors.black)));
                }),
            const Padding(
                padding: EdgeInsets.all(8.0), child: Text('Students')),
            ListView.builder(
                itemCount: controller.students.length,
                shrinkWrap: true,
                itemBuilder: (_, index) {
                  return Container(
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
                      child: Text(controller.students[index].name,
                          style: const TextStyle(color: Colors.black)));
                }),
          ],
        ),
      );
    });
  }
}

class SearchBarWidget extends StatelessWidget {
  final TeacherSearchPageController controller;
  const SearchBarWidget({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: AlignmentDirectional.centerStart, children: [
      heroSearchBar(),
      Container(
          color: Colors.white,
          margin: const EdgeInsets.fromLTRB(70, 0, 40, 5),
          child: TextField(
              controller: controller.searchController,
              onSubmitted: (value) =>
                  context.read<ItemsBloc>().add(RefreshItemsEvent(value))))
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
                Text('Search students',
                    style: TextStyle(fontSize: 18, color: Colors.grey))
              ],
            ),
          ),
        ));
  }
}
