import 'package:flutter/material.dart';
import 'package:teachent_app/controller/pages/settings_page/settings_page_controller.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';
import 'package:teachent_app/view/widgets/custom_button.dart';
import 'package:teachent_app/view/widgets/error_message_widget.dart';

/// Page with available settings from user perspective
/// Also page gets access to widget with all licence informations (see 'About app' button)
/// Input:
/// [userId] - user id (teacher or student id)
class SettingsPage extends StatefulWidget {
  final KeyId userId;
  const SettingsPage({Key? key, required this.userId}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late SettingsPageController _settingsPageController;

  @override
  void initState() {
    super.initState();
    _settingsPageController = SettingsPageController(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(slivers: [
        _appBar(context),
        SliverList(delegate: SliverChildListDelegate([_body()]))
      ]),
    );
  }

  Widget _appBar(BuildContext context) {
    return SliverAppBar(
        expandedHeight: 150,
        backgroundColor: Colors.transparent,
        leading: _back(context),
        flexibleSpace: FlexibleSpaceBar(
            title:
                const Text('Settings', style: TextStyle(color: Colors.black)),
            background: Container(color: Colors.transparent)));
  }

  Widget _back(BuildContext context) {
    return GestureDetector(
      onTap: () => _settingsPageController.backToHome(context),
      child: const Padding(
        padding: EdgeInsets.all(18.0),
        child: Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _body() {
    return FutureBuilder(
        future: _settingsPageController.init(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.connectionState == ConnectionState.done) {
            return _homeWidget(context);
          }
          return ErrorMessageWidget(
              text: snapshot.error.toString(),
              color: Colors.red,
              backgroundColor: Colors.blue);
        });
  }

  Widget _homeWidget(BuildContext context) {
    return SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Padding(
          padding: EdgeInsets.all(15),
          child: Text('Profile',
              style: TextStyle(color: Colors.black, fontSize: 14))),
      Padding(
          padding: const EdgeInsets.all(15),
          child: Text('Login: ${_settingsPageController.userId}',
              style: const TextStyle(color: Colors.black, fontSize: 18))),
      Padding(
          padding: const EdgeInsets.all(15),
          child: Text('Name: ${_settingsPageController.name}',
              style: const TextStyle(color: Colors.black, fontSize: 18))),
      Padding(
          padding: const EdgeInsets.all(15),
          child: CustomButton(
              text: 'Edit profile', fontSize: 18, onPressed: () {})),
      Padding(
          padding: const EdgeInsets.all(15),
          child: CustomButton(
              text: 'About app',
              fontSize: 18,
              onPressed: () {
                _settingsPageController.aboutDialog(context);
              })),
    ]));
  }
}
