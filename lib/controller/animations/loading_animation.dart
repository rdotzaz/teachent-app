import 'package:flutter/material.dart';

import 'base_animation.dart';

/// Controller for loading widgets animation
/// Can be used in every page when there are loaded some data in background
class LoadingAnimationController extends BaseAnimation<Color> {
  LoadingAnimationController()
    : super(duration: const Duration(milliseconds: 500),
            animation: ColorTween(begin: Colors.white, end: Colors.grey));
  
  @override
  void actions() {
    animController.repeat(reverse: true);
  }
}
