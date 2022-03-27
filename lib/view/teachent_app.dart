import 'package:flutter/material.dart';
import 'package:teachent_app/common/consts.dart' show NameConsts;
import 'package:teachent_app/view/pages/splash_page/splash_page.dart';

/// Main UI class
/// Creating main widget (MaterialApp) which is the root of whole pages tree
class TeachentApp extends StatelessWidget {
  const TeachentApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: NameConsts.appName,
      home: SplashPage(),
    );
  }
}
