import 'package:flutter/material.dart';
import 'package:teachent_app/controller/controller.dart';

import 'base_animation.dart';

/// Controller for Splash screen loading indicator
class SplashProgressIndicatorController extends BaseAnimation<double> {
  SplashProgressIndicatorController()
    : super(duration: const Duration(seconds: 2))
  
  @override
  void actions() {
    animationController.repeat(reverse: true);
  }
}
