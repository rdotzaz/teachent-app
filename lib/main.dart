import 'package:flutter/material.dart';
import 'package:teachent_app/database/database.dart';
import 'package:teachent_app/view/teachent_app.dart';

void main() async {
  await MainDatabase(DBMode.testing).init();
  runApp(const TeachentApp());
}
