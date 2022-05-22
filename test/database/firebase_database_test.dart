import 'package:firebase_database_mocks/firebase_database_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teachent_app/database/database.dart';

Future<MainDatabase> initDatabase() async {
  final firebaseMockReference = MockFirebaseDatabase.instance;
  final database = MainDatabase(instance: firebaseMockReference);

  await database.init(DBMode.release);

  return database;
}

void setFakeData(MainDatabase db) {
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
        'averageRate': 0.0,
        'description': '',
        'name': 'Jan Kowalski',
        'places': {'Warsaw': true},
        'topics': {'Computer Science': true}
      }
    },
    'students': {}
  };
  db.instance!.ref().set(fakeData);
}

void main() async {
  final db = await initDatabase();
  setFakeData(db);

  test('Dummy test', () {
    expect(2 + 2, 4);
  });

  test('TEST 1', () async {
    final teacher = await db.getTeacher('kowalski');

    expect(teacher == null, false);
  });
}