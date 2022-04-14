import 'package:flutter/material.dart';

/// Simple wrapper for ElevatedButton
class CustomButton extends StatelessWidget {
  final String text;
  final double fontSize;
  final void Function() onPressed;
  final Color buttonColor;
  final bool isEnabled;
  const CustomButton(
      {Key? key,
      required this.text,
      required this.fontSize,
      required this.onPressed,
      this.buttonColor = Colors.grey,
      this.isEnabled = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Container(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            text,
            style: TextStyle(fontSize: fontSize),
          )),
      onPressed: isEnabled ? onPressed : null,
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(buttonColor),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0)))),
    );
  }
}
