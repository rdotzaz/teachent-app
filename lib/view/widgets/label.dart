import 'package:flutter/material.dart';

class Label extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;
  final double padding;
  const Label({required this.text, this.color = Colors.black, this.fontSize = 18, this.padding = 15, Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Padding(
          padding: EdgeInsets.all(padding),
          child: Text(text,
              style: TextStyle(color: color, fontSize: fontSize)));
  }
}