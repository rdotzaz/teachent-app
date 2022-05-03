import 'package:flutter/material.dart';

/// Wrapper for ElevatedButton
/// Allows to maintain button status (enabled/disabled)
class EnabledButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final void Function() onPressed;
  final Color color;
  final Color enabledColor;
  final bool isEnabled;
  const EnabledButton(
      {Key? key,
      required this.text,
      required this.icon,
      required this.onPressed,
      required this.color,
      required this.enabledColor,
      required this.isEnabled})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(isEnabled ? enabledColor : color),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)))),
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 75, color: Colors.white),
                  Text(text,
                      style: const TextStyle(fontSize: 18, color: Colors.white))
                ],
              )),
          onPressed: onPressed),
    );
  }
}
