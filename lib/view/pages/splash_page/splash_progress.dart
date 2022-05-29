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
    return AnimatedBuilder(
        animation: splashProgressController.animation,
        builder: (context, child) {
          return Transform.rotate(
              angle: splashProgressController.value! * 45 / 180.0,
              child: Transform.scale(
                  scale: splashProgressController.value! * 0.5 + 1.0,
                  child: Image.asset(
                    'assets/app_logo.png',
                    scale: 4,
                  )));
        });
  }
}
