import 'package:teachent_app/common/consts.dart';
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
}
