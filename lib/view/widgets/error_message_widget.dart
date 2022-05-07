import 'package:flutter/material.dart';

class ErrorMessageWidget extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color color;
  const ErrorMessageWidget(
      {Key? key,
      required this.text,
      required this.backgroundColor,
      required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Column(children: [
        Padding(
            padding: const EdgeInsets.all(30),
            child: Icon(Icons.error, color: color)),
        Text(text, style: TextStyle(fontSize: 14, color: color)),
      ]),
    );
  }
}
