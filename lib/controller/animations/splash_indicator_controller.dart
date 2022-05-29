import 'package:flutter/animation.dart';

import 'base_animation.dart';

/// Controller for Splash screen loading indicator
class SplashProgressIndicatorController extends BaseAnimationWithTween<double> {
  SplashProgressIndicatorController()
      : super(
        duration: const Duration(milliseconds: 500),
        animationTween: CurveTween(curve: Curves.easeInBack));

  @override
  void actions() {
    animController.repeat(reverse: true);
  }
}
