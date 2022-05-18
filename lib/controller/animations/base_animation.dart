import 'package:flutter/material.dart';

/// Base animation controller class
/// Only [duration] and [animation] need to be specified
/// Also [actions] method allows e.g. start animation, repeat
class BaseAnimation<Value> {
  @protected
  late AnimationController animController;

  Value get value => animation != null ? animation.value : animController.value;
  bool get isAnimating => animController.isAnimating;

  final Duration duration;
  final Animation<Value>? animation;
  BaseAnimation({required this.duration, this.animation});

  void startAnimation(TickerProvider tickerProvider, void Function() refresh) {
    animController = AnimationController(vsync: tickerProvider, duration: duration);
    if (animation != null) {
      animation!.animate(animController);
    }
    animController.addListener(refresh);
    actions();
  }

  void actions();

  void stop() {
    animController.stop();
  }

  void dispose() {
    animController.dispose();
  }
}