import 'package:flutter_test/flutter_test.dart';
import 'package:teachent_app/controller/managers/review_manager.dart';
import 'package:teachent_app/model/db_objects/teacher.dart';

void main() {
  group('Average rate', () {
    late Teacher teacher1, teacher2, teacher3;
    setUp((() {
      teacher1 =
          Teacher('dummy', 'name', 'description', [], [], [], 0.0, [], [], []);
      teacher2 = Teacher(
          'dummy', 'name', 'description', [], [], [], 3.0, [], [], ['one']);
      teacher3 = Teacher('dummy', 'name', 'description', [], [], [], 10 / 3, [],
          [], ['one', 'two', 'three']);
    }));

    test('Empty average rate', () {
      expect(teacher1.averageRate, 0.0);
    });

    test('Average rate after adding one review', () {
      const newRate = 4;
      final newAverageRate =
          ReviewManager.getUpdatedAverageRate(teacher1, newRate);

      expect(newAverageRate, 4.0);
    });

    test('Average rate after adding another review', () {
      const newRate = 2;
      final newAverageRate =
          ReviewManager.getUpdatedAverageRate(teacher2, newRate);

      expect(newAverageRate, 2.5);
    });

    test('Average rate after adding many review', () {
      const newRate = 5;
      final newAverageRate =
          ReviewManager.getUpdatedAverageRate(teacher3, newRate);
      expect(newAverageRate, 3.75);
    });
  });
}
