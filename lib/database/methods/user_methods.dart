import 'package:teachent_app/database/adapters/firebase_adapter.dart';

import '../../model/db_objects/db_object.dart';
import '../../model/db_objects/user.dart';

mixin UserDatabaseMethods {
  void addUser(User user) {
    FirebaseRealTimeDatabaseAdapter.addUser(user.toMap(), user.collectionName);
  }

  void update(KeyId userId) {}

  void deleteUser(KeyId userId) {}
}
