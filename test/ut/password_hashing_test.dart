import 'package:flutter_test/flutter_test.dart';
import 'package:teachent_app/common/algorithms.dart';

void main() {
  group('Password hashing', () {
    test('Check simple password', () {
      const password = 'admin1';
      final hashedPassword = getHashedPassword(password);

      expect(isPasswordCorrect(password, hashedPassword), true);
    });

    test('Check if modified hash will break checking', () {
      const password = 'admin123456';
      final hashedPassword = getHashedPassword(password);

      final breakedPassword = hashedPassword + 'h';
      expect(isPasswordCorrect(password, breakedPassword), false);
    });
  });
}
