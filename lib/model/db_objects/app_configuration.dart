import 'package:teachent_app/model/db_objects/db_object.dart';

/// Object represents local configuration of app
/// Contains userId of logged user
/// Also booleans like isDarkMode and isTeacher
class AppConfiguration {
  final KeyId userId;
  final bool isDarkMode;
  final bool isTeacher;

  AppConfiguration(this.userId, this.isDarkMode, this.isTeacher);
}
