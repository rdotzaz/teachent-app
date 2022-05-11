import 'package:teachent_app/model/db_objects/db_object.dart';
import 'package:teachent_app/model/db_objects/user.dart';


/// Enum for status of login result
enum LoginStatus { success, loginNotFound, invalidPassword, logicError }

/// Login result with status and possible user object
/// if [status] = success, then [user] is not null, null otherwise
class LoginResult {
  final LoginStatus status;
  final User? user;

  LoginResult({required this.status, this.user});
}

/// Enum for status of request from student to teacher
/// [newReq] - status after newly created request by student
/// [waiting] - status possible after e.g. requesting new date by student
/// [responded] - status e.g. after rejected new date request
/// [rejected] - status of rejected request by teacher
/// [accepted] - status of accepted request by teacher
/// [invalid] - status when some unexpected error occured
enum RequestStatus { newReq, waiting, responded, rejected, accepted, invalid }

/// Enum for status of requested date by student
/// [none] - no date requested
/// [requested] - new date requested by student
/// [rejected] - new date rejected by teacher
/// [accepted] - new date accepted by teacher
/// [invalid] - status when some unexpected error occured
enum RequestedDateStatus { none, requested, accepted, rejected, invalid }

/// Enum for lesson cycle mode
/// [single] - single non-cycled lesson
/// [daily] - daily lessons
/// [weekly] - lesson repeats every week
/// [biweekly] - lesson repeats every two weeks
/// [monthly] - lesson repeats every month
enum CycleType { single, daily, weekly, biweekly, monthly }

/// Enum for lesson status
/// [open] - lesson is planned in the future
/// [teacherCancelled] - lesson has been cancelled by teacher
/// [studentCancelled] - lesson has been cancelled by student
enum LessonStatus { open, teacherCancelled, studentCancelled, finished }

/// Enum for person type in search page
/// [all] - search all users, teachers and students either
/// [teachers] - search only teachers
/// [students] - search only students
enum PersonType { all, teachers, students }

/// Enum for notification action
/// [none] - no notification for specific user
/// [lessonCancelled] - notification about lesson cancellation
/// [newRequest] - notification about new raised request by student
/// [acceptRequest] - notification about teacher request acceptance
/// [rejectRequest] - notification about teacher request rejection
enum NotificationAction { none, lessonCancelled, newRequest, acceptRequest, rejectRequest }


/// Enum for checked value in database
/// [none] - no norification for user
/// [present] - there is notification for user
/// [invalid] - there is an error during checking notifications
enum NotificationStatus { none, present, invalid }

class NotificationEntity {
  KeyId userId;
  NotificationStatus status;

  NotificationEntity({required this.userId, required this.status});
}
