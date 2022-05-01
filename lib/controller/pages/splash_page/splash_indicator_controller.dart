import 'package:flutter/material.dart';
import 'package:teachent_app/controller/controller.dart';

/// Controller for Splash screen loading indicator
class SplashProgressIndicatorController extends BaseController {
  late AnimationController animationController;

  double get animationValue => animationController.value;

  void startAnimation(TickerProvider tickerProvider, void Function() refresh) {
    animationController = AnimationController(
        vsync: tickerProvider, duration: const Duration(seconds: 2))
      ..addListener(refresh);
    animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
