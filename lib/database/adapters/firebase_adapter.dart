import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:teachent_app/database/database.dart';

import '../../common/consts.dart' show DatabaseConsts;
import '../../firebase_options.dart';

class FirebaseRealTimeDatabaseAdapter {
  static Future<void> init(DBMode dbMode) async {
    var databaseHost = _getHost(dbMode);
    await _startDataBase(dbMode, databaseHost);
  }

  static String _getHost(DBMode dbMode) {
    if (dbMode == DBMode.testing) {
      return DatabaseConsts.webFirebaseHost; //Platform.isAndroid
      //? DatabaseConsts.androidFirebaseHost
      //: DatabaseConsts.webFirebaseHost;
    } else {
      // TODO
      // Set real host
      return '?';
    }
  }

  static Future<void> _startDataBase(DBMode dbMode, String databaseHost) async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    if (dbMode == DBMode.testing) {
      FirebaseDatabase.instance
          .useDatabaseEmulator(databaseHost, DatabaseConsts.emulatorPort);
    }
  }

  static void addUser(DBValues userValues, String collectionName) async {
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref().child(collectionName);
    final newKeyId = databaseReference.push().key;

    await databaseReference.child(newKeyId!).set(userValues);
  }

  static void clear() {}
}
