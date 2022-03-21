import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_web_view/mobile_web_view.dart';
import 'package:teachent_app/common/consts.dart' show NameConsts;
import 'package:teachent_app/view/pages/splash_page.dart';

/// Main UI class
/// Creating main widget (MaterialApp) which is the root of whole pages tree
class TeachentApp extends StatelessWidget {
  const TeachentApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: NameConsts.appName,
      home: homeWidget(),
    );
  }

  Widget homeWidget() {
    return defaultTargetPlatform == TargetPlatform.android
        ? const SplashPage()
        : const MobileWebView(child: SplashPage());
  }
}
