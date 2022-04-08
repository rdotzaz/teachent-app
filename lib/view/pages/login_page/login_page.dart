import 'package:flutter/material.dart';
import 'package:teachent_app/common/consts.dart';
import 'package:teachent_app/controller/pages/login_page/login_form_controller.dart';
import 'package:teachent_app/view/pages/login_page/header_clipper.dart';

import '../../widgets/black_input_decorator.dart';
import '../../widgets/custom_button.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(resizeToAvoidBottomInset: false, body: LoginForm());
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _loginFormController = LoginFormController();

  @override
  Widget build(BuildContext context) {
    final windowSize = MediaQuery.of(context).size;

    return Form(
        key: _loginFormController.key,
        child: Column(
          children: [
            loginHeader(windowSize.height),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  loginLabel(),
                  loginTextField(),
                  passwordLabel(),
                  passwordTextField(),
                  submitButton()
                ],
              ),
            ),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [signUpLabel(), signUpButton()],
            ))
          ],
        ));
  }

  Stack loginHeader(double height) {
    return Stack(
      alignment: AlignmentDirectional.bottomStart,
      children: [
        ClipPath(
          clipper: LoginHeaderClipper(),
          child: Container(
            height: height / 4,
            color: Colors.grey,
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(25.0),
          child: Text(
            LoginPageConsts.logIn,
            style: TextStyle(fontSize: 28, color: Colors.white),
          ),
        )
      ],
    );
  }

  Container loginLabel() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.all(5.0),
      child: const Text(
        LoginPageConsts.login,
        style: TextStyle(fontSize: 18, color: Colors.black),
      ),
    );
  }

  Padding loginTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        keyboardType: TextInputType.text,
        validator: (login) => _loginFormController.validateLogin(login),
        onChanged: (login) => _loginFormController.setLogin(login),
        decoration: blackInputDecorator(LoginPageConsts.logIn),
      ),
    );
  }

  Container passwordLabel() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.all(5.0),
      child: const Text(
        LoginPageConsts.password,
        style: TextStyle(fontSize: 18, color: Colors.black),
      ),
    );
  }

  Padding passwordTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        obscureText: true,
        keyboardType: TextInputType.text,
        validator: (password) =>
            _loginFormController.validatePassword(password),
        onChanged: (password) => _loginFormController.setPassword(password),
        decoration: blackInputDecorator(LoginPageConsts.password),
      ),
    );
  }

  Padding submitButton() {
    return Padding(
        padding: const EdgeInsets.all(12.0),
        child: CustomButton(
          text: LoginPageConsts.logIn,
          fontSize: 28,
          onPressed: () => _loginFormController.buttonValidator(context),
        ));
  }

  Widget signUpLabel() {
    return Container(
      padding: const EdgeInsets.all(5.0),
      child: const Text(
        LoginPageConsts.signUpQuery,
        style: TextStyle(fontSize: 14, color: Colors.black),
      ),
    );
  }

  Widget signUpButton() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 30),
        child: CustomButton(
          text: LoginPageConsts.signUp,
          fontSize: 16,
          onPressed: () => _loginFormController.goToSignUpPage(context),
        ));
  }
}
