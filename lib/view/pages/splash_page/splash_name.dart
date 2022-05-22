import 'package:flutter/material.dart';

import '../../../common/consts.dart';

/// Widget on splash screen with app name
class SplashNameWidget extends StatelessWidget {
  const SplashNameWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(10.0),
      child: Text(
        NameConsts.appName,
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}
