import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:teachent_app/database/database.dart';
import 'package:teachent_app/view/main_app.dart';

void main() {
  startApplication();
}

void startApplication() async {
  await MainDatabase(DBMode.testing).init();
  runApp(const TeachentApp());
}
