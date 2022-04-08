import 'package:flutter/material.dart';
import 'package:teachent_app/controller/controller.dart';

// TODO - Remove this class
abstract class SearchPage<Controller extends BaseSearchController>
    extends StatelessWidget {
  final Controller controller;
  final String searchText;
  const SearchPage(
      {Key? key, required this.controller, required this.searchText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
