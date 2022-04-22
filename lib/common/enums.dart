import 'package:teachent_app/model/db_objects/user.dart';

enum LoginStatus { success, loginNotFound, invalidPassword, logicError }

class LoginResult {
  final LoginStatus status;
  final User? user;

  LoginResult({required this.status, this.user});
}

enum RequestStatus { waiting, responded, rejected, accepted, invalid }

extension RequestStatusExt on RequestStatus {
  int get value {
    if (this == RequestStatus.waiting) {
      return 0;
    }
    if (this == RequestStatus.responded) {
      return 1;
    }
    if (this == RequestStatus.rejected) {
      return 2;
    }
    if (this == RequestStatus.accepted) {
      return 3;
    }
    return -1;
  }
}
