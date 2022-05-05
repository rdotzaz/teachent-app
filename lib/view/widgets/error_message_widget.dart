import 'package:flutter/material.dart';

class ErrorMessageWidget extends StatelessWidget {
  final String text;
  const ErrorMessageWidget({ Key? key, required this.text }) : super(key: key);

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