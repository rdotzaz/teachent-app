import 'package:flutter/material.dart';

/// Base animation with tween controller class
/// Only [duration] and [animationTween] need to be specified
/// Also [actions] method allows e.g. start animation, repeat
abstract class BaseAnimationWithTween<Value> {
  @protected
  late AnimationController animController;
  @protected
  late Animation<Value?> animation;

  Value? get value => animation.value;
  bool get isAnimating => animController.isAnimating;

  final Duration duration;
  final Animatable<Value?> animationTween;
  BaseAnimationWithTween({required this.duration, required this.animationTween});

  void startAnimation(TickerProvider tickerProvider, void Function() refresh) {
    animController = AnimationController(vsync: tickerProvider, duration: duration);
    animation = animationTween.animate(animController);
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

/// Base animation controller class
/// Only [duration] needs to be specified
/// Also [actions] method allows e.g. start animation, repeat
abstract class BaseAnimation {
  @protected
  late AnimationController animController;

  double get value => animController.value;
  bool get isAnimating => animController.isAnimating;

  final Duration duration;
  BaseAnimation({required this.duration});

  void startAnimation(TickerProvider tickerProvider, void Function() refresh) {
    animController = AnimationController(vsync: tickerProvider, duration: duration);
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

