import 'package:flutter/material.dart';
import 'package:teachent_app/database/database.dart';
import 'package:teachent_app/view/teachent_app.dart';

/// Initialize database inside app
/// Start app
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MainDatabase().init(DBMode.release);
  runApp(const TeachentApp());
}
