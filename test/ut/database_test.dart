import 'package:flutter_test/flutter_test.dart';

import 'database_utils.dart';

void main() {
  final db = initDatabase();
  setFakeValues(db);
  test('Dummy test', () {
    expect(2 + 2, 4);
  });

  test('TEST 1', () async {
    final dbRef = db.fbReference?.ref().child('teachers');

    if (dbRef == null) {
      print('Null');
      return;
    }
    print('Value');
    final event = await dbRef.once();

    print(event.snapshot.value);
    expect(event.snapshot.value, {});
  });

  test('TEST 2', () async {
    final teacher = await db.getTeacher('kowalski');

    assert(teacher != null);

    print(teacher?.toMap());
    expect(teacher?.toMap() ?? {}, {
      'averageRate': -1,
      'description': '',
      'name': 'Jan Kowalski',
      'places': {'Warsaw': true},
      'topics': {'Computer Science': true}
    });
  });
}
