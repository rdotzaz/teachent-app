import 'package:flutter/material.dart';

class ErrorWidget extends StatelessWidget {
  final String text;
  const ErrorWidget({ Key? key, required this.text }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Container(
      color: Colors.red,
      child: Column(children: [
        const Padding(
            padding: EdgeInsets.all(30),
            child: Icon(Icons.error, color: Colors.white)),
        Text(text),
      ]),
    );
  }
}