import 'package:flutter/material.dart';

import 'base_animation.dart';

/// Controller for loading widgets animation
/// Can be used in every page when there are loaded some data in background
class LoadingAnimationController extends BaseAnimationWithTween<Color> {
  LoadingAnimationController()
      : super(
            duration: const Duration(milliseconds: 500),
            animationTween:
                ColorTween(begin: Colors.grey[100], end: Colors.grey[300]));

  @override
  void actions() {
    animController.repeat(reverse: true);
  }
}
