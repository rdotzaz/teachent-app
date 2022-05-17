import 'package:flutter/material.dart';

/// Controller for loading widgets animation
/// Can be used in every page when there are loaded some data in background
class LoadingAnimationController {
    late AnimationController _loadingController;
    late Animation _loadingAnimation;

    Color get animationValue => _loadingAnimation.value;
    bool get isAnimating => _loadingController.isAnimating;

    void startAnimation(TickerProvider tickerProvider, void Function() refresh) {
        _loadingController = AnimationController(
            vsync: tickerProvider, duration: const Duration(milliseconds: 500));
        _loadingAnimation = ColorTween(begin: Colors.white, end: Colors.grey)
            .animate(_loadingController);
        _loadingController.addListener(refresh);
        _loadingController.repeat(reverse: true);
    }

    void stop() {
        _loadingController.stop();
    }

    void dispose() {
        _loadingController.dispose();
    }
}