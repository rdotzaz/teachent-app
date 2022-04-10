import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database_mocks/firebase_database_mocks.dart';
import 'package:teachent_app/database/database.dart';

MainDatabase initDatabase() {
  final fbReference = MockFirebaseDatabase.instance;
  final db = MainDatabase.customDb(fbReference);

  db.init(DBMode.testing);

  return db;
}

void setFakeValues(MainDatabase db) {
  final fakeData = {
    'levels': {'High School': false, 'Primary': false, 'University': false},
    'places': {'Warsaw': false, 'Wroclaw': false},
    'topics': {'Computer Science': false, 'Math': false},
    'tools': {'Discord': false},
    'users': {
      'kowalski': {
        'isDarkMode': false,
        'isTeacher': false,
        'password': 'admin1'
      }
    },
    'teachers': {
      'kowalski': {
        'averageRate': -1,
        'description': '',
        'name': 'Jan Kowalski',
        'places': {'Warsaw': true},
        'topics': {'Computer Science': true}
      }
    },
    'students': {}
  };
  db.fbReference?.ref().set(fakeData);
}
