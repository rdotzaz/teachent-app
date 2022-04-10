import 'package:flutter/material.dart';
import 'package:teachent_app/controller/pages/settings_page/settings_page_controller.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';

class SettingsPage extends StatefulWidget {
  final KeyId userId;
  const SettingsPage({ Key? key, required this.userId}) : super(key: key);

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
    return CustomScrollView(
        slivers: [
            appBar(context),
            SliverList(
                delegate: SliverChildListDelegate([
                    body()
                ])
            )
        ]
    );
  }

  Widget appBar(BuildContext context) {
      return SliverAppBar(
          expandedHeight: 150,
          backgroundColor: Colors.transparent,
          leading: back(context),
          flexibleSpace: FlexibleSpaceBar(
              title: const Text('Settings',
                style: TextStyle(color: Colors.black)),
              background: Container(color: Colors.transparent)
          )
      );
  }

  Widget back(BuildContext context) {
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

  Widget body() {
      return FutureBuilder(
          future: _settingsPageController.init(),
          builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.connectionState == ConnectionState.done) {
              return homeWidget();
            }
            return errorWidget(snapshot.error.toString());
          }
      );
  }

  Widget homeWidget() {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text(
                      _settingsPageController.userId,
                  )
              ),
          ]
      );
  }

  Widget errorWidget(String errorMessage) {
    return Container(
      color: Colors.red,
      child: Column(children: [
        const Padding(
            padding: EdgeInsets.all(30),
            child: Icon(Icons.error, color: Colors.white)),
        Text(errorMessage),
      ]),
    );
  }
}
