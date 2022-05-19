import 'base_animation.dart';

/// Controller for Splash screen loading indicator
class SplashProgressIndicatorController extends BaseAnimation {
  SplashProgressIndicatorController()
    : super(duration: const Duration(seconds: 2));
  
  @override
  void actions() {
    animController.repeat(reverse: true);
  }
}
