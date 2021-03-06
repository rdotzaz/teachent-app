import 'package:teachent_app/common/consts.dart';
import 'package:teachent_app/common/date.dart';
import 'package:teachent_app/common/enums.dart';
import 'package:teachent_app/common/enum_functions.dart';
import 'package:teachent_app/common/firebase_enums.dart';
import 'package:teachent_app/database/adapters/firebase_adapter.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';
import 'package:teachent_app/model/db_objects/request.dart';
import 'package:teachent_app/model/objects/topic.dart';

/// Methods to maintain Request object in database
mixin RequestDatabaseMethods {
  /// Returns Request object by [requestId].
  /// If object with [requestId] does not exist, returns null
  Future<Request?> getRequest(KeyId requestId) async {
    final response = await FirebaseRealTimeDatabaseAdapter.getObject(
        DatabaseObjectName.requests, requestId);
    if (response.status == FirebaseResponseStatus.failure) {
      return null;
    }
    return Request.fromMap(requestId, response.data);
  }

  /// Returns list of Request objects based on [requestIds]
  Future<Iterable<Request>> getRequests(List<KeyId> requestIds) async {
    final requests = <Request>[];
    for (final requestId in requestIds) {
      final request = await getRequest(requestId);
      if (request == null) {
        continue;
      }
      requests.add(request);
    }
    return requests;
  }

  /// Methdd adds request to database.
  /// If request was successfully added, new request key is returned.
  /// Otherwise returns null
  Future<KeyId?> addRequest(Request request) async {
    final response =
        await FirebaseRealTimeDatabaseAdapter.addDatabaseObjectWithNewKey(
            DatabaseObjectName.requests, request.toMap());
    if (response.status == FirebaseResponseStatus.failure) {
      return null;
    }
    return response.data;
  }

  /// Update requested date from request with [requestId] with [newDate]
  Future<void> changeRequestedDate(KeyId requestId, DateTime newDate) async {
    await FirebaseRealTimeDatabaseAdapter.updateField(
        DatabaseObjectName.requests,
        requestId,
        'requestedDate',
        DateFormatter.getString(newDate));
  }

  /// Update request stauts from request with [requestId] with [newStatus]
  Future<void> changeRequestStatus(
      KeyId requestId, RequestStatus newStatus) async {
    await FirebaseRealTimeDatabaseAdapter.updateField(
        DatabaseObjectName.requests, requestId, 'status', newStatus.value);
  }

  /// Update requested date status from request with [requestId] with [newStatus]
  Future<void> changeRequestedDateStatus(
      KeyId requestId, RequestedDateStatus newStatus) async {
    await FirebaseRealTimeDatabaseAdapter.updateField(
        DatabaseObjectName.requests, requestId, 'dateStatus', newStatus.value);
  }

  /// Update current date from request with [requestId] with [newDate]
  Future<void> changeCurrentDate(KeyId requestId, DateTime newDate) async {
    await FirebaseRealTimeDatabaseAdapter.updateField(
        DatabaseObjectName.requests,
        requestId,
        'currentDate',
        DateFormatter.getString(newDate));
  }

  /// Update current topic from request with [requestId] with [topic]
  Future<void> changeTopic(KeyId requestId, Topic topic) async {
    await FirebaseRealTimeDatabaseAdapter.updateField(
        DatabaseObjectName.requests, requestId, 'topic', topic.name);
  }
}
