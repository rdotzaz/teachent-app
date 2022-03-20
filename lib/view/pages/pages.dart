import 'package:flutter/material.dart';

import '../../controller/controller.dart';

class GenericState<S extends StatefulWidget> extends State<S> {
  final BasePageController controller;

  GenericState(this.controller);

  @override
  void initState() {
    controller.init();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
