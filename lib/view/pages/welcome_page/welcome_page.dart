import 'package:flutter/material.dart';
import 'package:teachent_app/common/consts.dart';
import 'package:teachent_app/controller/pages/welcome_page/welcome_page_controller.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';

/// Page shows after successful account creation
/// Input:
/// [dbObject] - teacher or student object
class WelcomePage extends StatefulWidget {
  final DatabaseObject dbObject;
  const WelcomePage({Key? key, required this.dbObject}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  late WelcomePageController _welcomePageController;

  @override
  void initState() {
    super.initState();
    _welcomePageController = WelcomePageController(context, widget.dbObject);
    _welcomePageController.init();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: Text(WelcomePageConsts.welcome)));
  }
}
