import 'package:flutter/material.dart';
import 'package:teachent_app/controller/pages/search_page/teacher_search_page_controller.dart';

import 'search_page.dart';

class TeacherSearchPage extends SearchPage<TeacherSearchPageController> {
  TeacherSearchPage({Key? key})
      : super(
            key: key,
            searchText: 'Search students',
            controller: TeacherSearchPageController());

  @override
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

  @override
  Widget foundListWidget() {
    return const Expanded(child: Center(child: Text('No items found')));
  }
}
