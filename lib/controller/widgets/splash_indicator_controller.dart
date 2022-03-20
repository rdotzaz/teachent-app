import 'package:flutter/material.dart';
import 'package:teachent_app/controller/controller.dart';

class SplashProgressIndicatorController extends BaseController {
  late AnimationController animationController;

  double get animationValue => animationController.value;

  void startAnimation(TickerProvider tickerProvider, void Function() refresh) {
    animationController = AnimationController(
        vsync: tickerProvider, duration: const Duration(seconds: 2))
      ..addListener(refresh);
    animationController.repeat(reverse: false);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
