import 'package:flutter/material.dart';

/// Custom input decorator with black accent
InputDecoration blackInputDecorator(String label) {
  return InputDecoration(
      floatingLabelStyle: const TextStyle(color: Colors.black),
      border: const OutlineInputBorder(),
      focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 1.5),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      labelText: label);
}
