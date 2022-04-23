import 'package:teachent_app/model/db_objects/user.dart';

enum LoginStatus { success, loginNotFound, invalidPassword, logicError }

class LoginResult {
  final LoginStatus status;
  final User? user;

  LoginResult({required this.status, this.user});
}

enum RequestStatus {newReq, waiting, responded, rejected, accepted, invalid }

extension RequestStatusExt on RequestStatus {
  int get value {
    if (this == RequestStatus.newReq) {
      return 0;
    }
    if (this == RequestStatus.waiting) {
      return 1;
    }
    if (this == RequestStatus.responded) {
      return 2;
    }
    if (this == RequestStatus.rejected) {
      return 3;
    }
    if (this == RequestStatus.accepted) {
      return 4;
    }
    return -1;
  }
}

enum CycleType { single, daily, weekly, biweekly, monthly }

extension CycleTypeExt on CycleType {
  int get value {
    if (this == CycleType.single) {
      return 0;
    }
    if (this == CycleType.daily) {
      return 1;
    }
    if (this == CycleType.weekly) {
      return 2;
    }
    if (this == CycleType.biweekly) {
      return 3;
    }
    return 4;
  }
}

CycleType getCycleByValue(int value) {
    if (value == 0) {
      return CycleType.single;
    }
    if (value == 1) {
      return CycleType.daily;
    }
    if (value == 2) {
      return CycleType.weekly;
    }
    if (value == 3) {
      return CycleType.biweekly;
    }
    return CycleType.monthly;
}

RequestStatus getStatusByValue(int value) {
    if (value == 0) {
      return RequestStatus.newReq;
    }
    if (value == 1) {
      return RequestStatus.waiting;
    }
    if (value == 2) {
      return RequestStatus.responded;
    }
    if (value == 3) {
      return RequestStatus.rejected;
    }
    if (value == 4) {
      return RequestStatus.accepted;
    }
    return RequestStatus.invalid;
}
