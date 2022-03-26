import 'package:flutter/material.dart';
import 'package:teachent_app/controller/pages/splash_page/splash_page_controller.dart';
import 'package:teachent_app/view/pages/splash_page/splash_progress.dart';

import 'splash_name.dart';

/// First page after launching app
/// Displaying logo and loading requiered componentes
class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  final SplashPageController splashPageController = SplashPageController();

  @override
  void initState() {
    splashPageController.init();
    splashPageController.nextPage(context);
    super.initState();
  }

  @override
  void dispose() {
    splashPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            SplashNameWidget(),
            SplashProgressIndicatorWidget(),
          ],
        ),
      ),
    );
  }
}
