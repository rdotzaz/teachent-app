import 'package:flutter_test/flutter_test.dart';

import 'database_utils.dart';

void main() {
  final db = initDatabase();
  test('Dummy test', () {
    expect(2 + 2, 4);
  });
}
