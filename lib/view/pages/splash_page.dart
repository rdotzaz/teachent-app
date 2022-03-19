import 'package:flutter/material.dart';
import 'package:teachent_app/common/consts.dart' show NameConsts;

/// First page after launching app
/// Displaying logo and loading requiered componentes
class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: const Center(
        child: Text(NameConsts.welcomeText),
      ),
    );
  }
}
