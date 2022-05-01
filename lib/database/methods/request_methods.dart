import 'package:teachent_app/common/consts.dart';
import 'package:teachent_app/common/enums.dart';
import 'package:teachent_app/common/enum_functions.dart';
import 'package:teachent_app/database/adapters/firebase_adapter.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';
import 'package:teachent_app/model/db_objects/request.dart';

mixin RequestDatabaseMethods {
  Future<Request?> getRequest(KeyId requestId) async {
    final requestValues = await FirebaseRealTimeDatabaseAdapter.getObject(
        DatabaseObjectName.requests, requestId);
    if (requestValues.isEmpty) {
      return null;
    }
    return Request.fromMap(requestId, requestValues);
  }

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

  Future<KeyId?> addRequest(Request request) async {
    final newKey =
        await FirebaseRealTimeDatabaseAdapter.addDatabaseObjectWithNewKey(
            DatabaseObjectName.requests, request.toMap());
    if (newKey == DatabaseConsts.emptyKey) {
      print('Request has not been added');
      return null;
    }
    return newKey;
  }

  Future<void> changeRequestedDate(KeyId requestId, String newDate) async {
    await FirebaseRealTimeDatabaseAdapter.updateField(
        DatabaseObjectName.requests, requestId, 'requestedDate', newDate);
  }

  Future<void> changeRequestStatus(
      KeyId requestId, RequestStatus newStatus) async {
    await FirebaseRealTimeDatabaseAdapter.updateField(
        DatabaseObjectName.requests, requestId, 'status', newStatus.value);
  }

  Future<void> changeRequestedDateStatus(
      KeyId requestId, RequestedDateStatus newStatus) async {
    await FirebaseRealTimeDatabaseAdapter.updateField(
        DatabaseObjectName.requests, requestId, 'dateStatus', newStatus.value);
  }

  Future<void> changeRequestDate(KeyId requestId, String newDate) async {
    await FirebaseRealTimeDatabaseAdapter.updateField(
        DatabaseObjectName.requests, requestId, 'currentDate', newDate);
  }
}
