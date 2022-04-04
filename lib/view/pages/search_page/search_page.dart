import 'package:flutter/material.dart';
import 'package:teachent_app/controller/controller.dart';

abstract class SearchPage<Controller extends BaseSearchController>
    extends StatelessWidget {
  final Controller controller;
  final String searchText;
  const SearchPage(
      {Key? key, required this.controller, required this.searchText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: Column(
          children: [searchBarWidget(), filtersWidget(), foundListWidget()],
        ));
  }

  Widget searchBarWidget() {
    return Stack(alignment: AlignmentDirectional.centerStart, children: [
      heroSearchBar(),
      Container(
        color: Colors.white,
        margin: const EdgeInsets.fromLTRB(70, 0, 40, 5),
        child: TextField(
            controller: controller.searchController,
            onChanged: (value) => controller.setValue(value)),
      )
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
              children: [
                const Icon(Icons.search, color: Colors.grey, size: 25),
                const SizedBox(width: 20),
                Text(searchText,
                    style: const TextStyle(fontSize: 18, color: Colors.grey))
              ],
            ),
          ),
        ));
  }

  Widget filtersWidget();

  Widget foundListWidget();
}
