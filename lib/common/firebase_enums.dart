import 'package:teachent_app/common/enums.dart';

/// Enum for firebase response status
/// [success] - successful operation on database. Data can be retrived from response
/// [failure] - failure operation on database. See feedback
enum FirebaseResponseStatus { success, failure }

/// Enum for firebase response feedback in case of failure operation on database
/// [none] - successful operation on database. No feedback provided
/// [noData] - successful operation on database, but on data found
/// [connectionError] - no connection with database or connection timeout
/// [logicError] - error during database logic execution
/// [keyAlreadyExists] - error during adding database object with already existing key
/// [noKeyFound] - key does not exist in database
enum FirebaseFeedback {
  none,
  noData,
  connectionError,
  logicError,
  keyAlreadyExists,
  noKeyFound
}

/// Base class for firebase response
/// It is returned from every method from firebase_adapter which access or store data in database
/// [loginResult] - available only after login and password checking
class FirebaseResponse<T> {
  final FirebaseResponseStatus status;
  final FirebaseFeedback feedback;
  final LoginResult? loginResult;
  final T data;

  FirebaseResponse(
      {required this.status,
      required this.feedback,
      this.loginResult,
      required this.data});
}
