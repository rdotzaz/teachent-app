import 'package:flutter/material.dart';
import 'package:teachent_app/common/consts.dart' show NameConsts;
import 'package:teachent_app/controller/pages/splash_page_controller.dart';
import 'package:teachent_app/view/pages/pages.dart';

/// First page after launching app
/// Displaying logo and loading requiered componentes
class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends GenericState<SplashPage> {
  _SplashPageState() : super(SplashPageController());

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Center(
        child: Column(
          children: [
            const Text(
              NameConsts.appName,
              style: TextStyle(color: Colors.yellow, fontSize: 20),
            ),
            Container(
              color: Colors.green,
            )
          ],
        ),
      ),
    );
  }
}
