import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database_mocks/firebase_database_mocks.dart';
import 'package:teachent_app/database/database.dart';

MainDatabase initDatabase() {
  final fbReference = MockFirebaseDatabase.instance;
  final db = MainDatabase.customDb(fbReference);

  db.init(DBMode.testing);

  return db;
}
