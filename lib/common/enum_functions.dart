import 'enums.dart';

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

  String get stringValue {
    if (this == RequestStatus.newReq) {
      return 'New request has been sent';
    }
    if (this == RequestStatus.waiting) {
      return 'Waiting for new response';
    }
    if (this == RequestStatus.responded) {
      return 'Responded';
    }
    if (this == RequestStatus.rejected) {
      return 'Request rejected';
    }
    if (this == RequestStatus.accepted) {
      return 'Request accepted';
    }
    return 'Error';
  }
}

extension RequestedDateStatusExt on RequestedDateStatus {
  int get value {
    if (this == RequestedDateStatus.none) {
      return 0;
    }
    if (this == RequestedDateStatus.requested) {
      return 1;
    }
    if (this == RequestedDateStatus.accepted) {
      return 2;
    }
    if (this == RequestedDateStatus.rejected) {
      return 3;
    }
    return -1;
  }

  String get stringValue {
    if (this == RequestedDateStatus.none) {
      return 'No new date requested';
    }
    if (this == RequestedDateStatus.requested) {
      return 'New date requested';
    }
    if (this == RequestedDateStatus.accepted) {
      return 'New date was accepted';
    }
    if (this == RequestedDateStatus.rejected) {
      return 'New date was rejected';
    }
    return 'Error';
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

RequestStatus getRequestStatusByValue(int value) {
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

RequestedDateStatus getRequestedDateStatusByValue(int value) {
  if (value == 0) {
    return RequestedDateStatus.none;
  }
  if (value == 1) {
    return RequestedDateStatus.requested;
  }
  if (value == 2) {
    return RequestedDateStatus.accepted;
  }
  if (value == 3) {
    return RequestedDateStatus.rejected;
  }
  return RequestedDateStatus.invalid;
}