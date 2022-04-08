import 'package:flutter/material.dart';
import 'package:teachent_app/controller/pages/search_page/student_search_page_controller.dart';
import 'package:teachent_app/view/pages/search_page/search_page.dart';

class StudentSearchPage extends SearchPage<StudentSearchPageController> {
  StudentSearchPage({Key? key})
      : super(
            key: key,
            searchText: 'Search teachers...',
            controller: StudentSearchPageController());

  @override
  Widget filtersWidget() {
    throw UnimplementedError();
  }

  @override
  Widget foundListWidget() {
    throw UnimplementedError();
  }
}
