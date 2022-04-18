import 'package:teachent_app/common/consts.dart';
import 'package:teachent_app/database/adapters/firebase_adapter.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';
import 'package:teachent_app/model/db_objects/request.dart';

mixin RequestDatabaseMethods {
  Future<Iterable<Request>> getRequests(List<KeyId> requestIds) async {
    final requests = <Request>[];
    for (final requestId in requestIds) {
      final requestValues = await FirebaseRealTimeDatabaseAdapter.getObject(
          DatabaseObjectName.requests, requestId);

      if (requestValues.isEmpty) {
        continue;
      }
      requests.add(Request.fromMap(requestId, requestValues));
    }
    return requests;
  }
}
