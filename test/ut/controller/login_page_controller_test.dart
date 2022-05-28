import 'package:flutter_test/flutter_test.dart';
import 'package:teachent_app/common/consts.dart';
import 'package:teachent_app/controller/pages/login_page/login_form_controller.dart';

void main() {
  late LoginFormController loginFormController;

  group('Login and password', () {
    setUp(() {
      loginFormController = LoginFormController();
    });

    test('Validate setting incorrect login', () {
      expect(
          loginFormController.validateLogin(null), LoginPageConsts.loginError);
    });

    test('Validate setting login', () {
      expect(loginFormController.validateLogin('kowalski'), null);
    });

    test('Validate setting incorrect password', () {
      expect(loginFormController.validatePassword(null),
          LoginPageConsts.passwordError);
    });

    test('Validate setting password', () {
      expect(loginFormController.validatePassword('admin1'), null);
    });
  });
}
