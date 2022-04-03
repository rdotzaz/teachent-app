import 'package:flutter/material.dart';
import 'package:teachent_app/controller/pages/search_page/search_page.dart';

class SearchPage extends StatelessWidget {
  final _searchPageController = SearchPageController();

  SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [searchBarWidget()],
    ));
  }

  Widget searchBarWidget() {
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
                Text('Search students...',
                    style: TextStyle(fontSize: 18, color: Colors.grey))
              ],
            ),
          ),
        ));
  }
}
