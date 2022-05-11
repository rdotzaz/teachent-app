import 'package:flutter/material.dart';
import 'package:teachent_app/controller/notifications/notification_manager.dart';
import 'package:teachent_app/database/database.dart';
import 'package:teachent_app/view/teachent_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MainDatabase().init(DBMode.testing);
  runApp(const TeachentApp());
  //NotificationManager.register();
}
