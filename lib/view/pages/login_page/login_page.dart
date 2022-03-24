import 'package:flutter/material.dart';
import 'package:teachent_app/controller/pages/login_page/login_form_controller.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Log in'), shadowColor: Colors.grey),
        body: const LoginForm());
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
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
            key: _loginFormController.key,
            child: Column(
              children: [loginTextField(), passwordTextField(), submitButton()],
            )));
  }

  Padding loginTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        keyboardType: TextInputType.text,
        validator: (login) => _loginFormController.validateLogin(login),
        onSaved: (login) {
          _loginFormController.setLogin(login);
        },
        decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Login',
            hintText: 'Login field'),
      ),
    );
  }

  Padding passwordTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        keyboardType: TextInputType.text,
        validator: (password) =>
            _loginFormController.validatePassword(password),
        onSaved: (password) {
          _loginFormController.setPassword(password);
        },
        decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Password',
            hintText: 'Password field'),
      ),
    );
  }

  Padding submitButton() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ElevatedButton(
        child: const Text('Log in'),
        onPressed: () async {
          await _loginFormController.buttonValidator(context);
        },
        style: ButtonStyle(
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)))),
      ),
    );
  }
}
