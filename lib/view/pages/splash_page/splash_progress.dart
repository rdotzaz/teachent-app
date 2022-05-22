import 'package:flutter/material.dart';
import 'package:teachent_app/controller/animations/splash_indicator_controller.dart';

/// Widget on splash screen responsible for animating circular indicator
class SplashProgressIndicatorWidget extends StatefulWidget {
  const SplashProgressIndicatorWidget({Key? key}) : super(key: key);

  @override
  State<SplashProgressIndicatorWidget> createState() =>
      _SplashProgressIndicatorWidgetState();
}

class _SplashProgressIndicatorWidgetState
    extends State<SplashProgressIndicatorWidget>
    with SingleTickerProviderStateMixin {
  final SplashProgressIndicatorController splashProgressController =
      SplashProgressIndicatorController();

  @override
  void initState() {
    splashProgressController.startAnimation(this, refresh);
    super.initState();
  }

  @override
  void dispose() {
    splashProgressController.dispose();
    super.dispose();
  }

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(15.0),
        child: CircularProgressIndicator(
          value: splashProgressController.value,
          valueColor: const AlwaysStoppedAnimation(Colors.black),
        ));
  }
}
