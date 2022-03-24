import 'package:teachent_app/model/db_objects/db_object.dart';

class AppConfiguration {
  final KeyId userId;
  final bool isDarkMode;
  final bool isTeacher;

  AppConfiguration(this.userId, this.isDarkMode, this.isTeacher);
}
