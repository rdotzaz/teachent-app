import 'enums.dart';

/// Extend RequestStatus enum with useful getters
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

/// Extend RequestedDateStatus enum with useful getters
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

/// Extend CycleType enum with useful getters
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

  String get stringValue {
    if (this == CycleType.single) {
      return 'Single lesson';
    }
    if (this == CycleType.daily) {
      return 'Daily lessons';
    }
    if (this == CycleType.weekly) {
      return 'Weekly lessons';
    }
    if (this == CycleType.biweekly) {
      return 'Biweekly lessons';
    }
    return 'Monthly lessons';
  }
}

/// Extend LessonStatus enum with useful getters
extension LessonStatusExt on LessonStatus {
  int get value {
    if (this == LessonStatus.open) {
      return 0;
    }
    if (this == LessonStatus.teacherCancelled) {
      return 1;
    }
    if (this == LessonStatus.studentCancelled) {
      return 2;
    }
    return 3;
  }

  String get stringValue {
    if (this == LessonStatus.open) {
      return 'Open';
    }
    if (this == LessonStatus.teacherCancelled) {
      return 'Lesson cancelled by teacher';
    }
    if (this == LessonStatus.studentCancelled) {
      return 'Lesson cancelled by student';
    }
    return 'Lesson completed';
  }
}

extension ReviewRateExt on ReviewRate {
  int get value {
    if (this == ReviewRate.one) {
      return 1;
    }
    if (this == ReviewRate.two) {
      return 2;
    }
    if (this == ReviewRate.three) {
      return 3;
    }
    if (this == ReviewRate.four) {
      return 4;
    }
    return 5;
  }
}

/// Returns CycleType enum based on value from database
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

/// Returns RequestStatus enum based on value from database
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

/// Returns RequestedDateStatus enum based on value from database
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

/// Returns LessonStatus enum based on value from database
LessonStatus getLessonStatusStatusByValue(int value) {
  if (value == 0) {
    return LessonStatus.open;
  }
  if (value == 1) {
    return LessonStatus.teacherCancelled;
  }
  if (value == 2) {
    return LessonStatus.studentCancelled;
  }
  return LessonStatus.finished;
}

/// Returns ReviewRate enum based on value from database
ReviewRate getReviewRateByValue(int value) {
  if (value == 1) {
    return ReviewRate.one;
  }
  if (value == 2) {
    return ReviewRate.two;
  }
  if (value == 3) {
    return ReviewRate.three;
  }
  if (value == 4) {
    return ReviewRate.four;
  }
  return ReviewRate.five;
}
