import 'package:teachent_app/model/db_objects/user.dart';

enum LoginStatus {
  success,
  loginNotFound,
  invalidPassword,
  logicError
}

class LoginResult {
  final LoginStatus status;
  final User? user;

  LoginResult({required this.status, this.user});  
}