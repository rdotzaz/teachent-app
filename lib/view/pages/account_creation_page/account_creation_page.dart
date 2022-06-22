import 'package:flutter/material.dart';
import 'package:teachent_app/common/consts.dart';
import 'package:teachent_app/controller/pages/account_creation/account_creation_page_controller.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';
import 'package:teachent_app/view/pages/login_page/header_clipper.dart';
import 'package:teachent_app/view/widgets/black_input_decorator.dart';
import 'package:teachent_app/view/widgets/custom_button.dart';

/// Page which is showing after TeacherCreationPage or StudentCreationPage
/// Input:
/// [dbObject] - teacher or student object created in previous page
///
/// On page user specifies login and password.
/// After subitting teacher and related objects are stored in database
class AccountCreationPage extends StatefulWidget {
  final DatabaseObject dbObject;
  const AccountCreationPage(this.dbObject, {Key? key}) : super(key: key);

  @override
  _AccountCreationPageState createState() => _AccountCreationPageState();
}

class _AccountCreationPageState extends State<AccountCreationPage> {
  late AccountCreationPageController _accountCreationPageController;

  @override
  void initState() {
    super.initState();
    _accountCreationPageController =
        AccountCreationPageController(widget.dbObject);
    _accountCreationPageController.init();
  }

  @override
  void dispose() {
    _accountCreationPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final windowSize = MediaQuery.of(context).size;
    return Scaffold(
        body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(children: [header(windowSize.height), body()])));
  }

  Widget header(double height) {
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
            AccountCreationPageConsts.header,
            style: TextStyle(fontSize: 28, color: Colors.white),
          ),
        )
      ],
    );
  }

  Widget body() {
    return Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(children: [
          profileLabel(),
          nameLabel(),
          accountForm(),
          submitButton()
        ]));
  }

  Widget profileLabel() {
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
            child: Text(_accountCreationPageController.profileName,
                style: const TextStyle(fontSize: 16, color: Colors.black))));
  }

  Widget nameLabel() {
    return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Center(
            child: Text(_accountCreationPageController.name,
                style: const TextStyle(fontSize: 16, color: Colors.black))));
  }

  Widget accountForm() {
    return Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
            key: _accountCreationPageController.creationKey,
            child: Column(children: [
              loginLabel(),
              loginTextField(),
              passwordLabel(),
              passwordTextField(),
              repeatPasswordLabel(),
              repeatPasswordTextField()
            ])));
  }

  Container loginLabel() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.all(5.0),
      child: const Text(
        'Login',
        style: TextStyle(fontSize: 18, color: Colors.black),
      ),
    );
  }

  Padding loginTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        keyboardType: TextInputType.text,
        validator: (login) =>
            _accountCreationPageController.validateLogin(login),
        onChanged: (login) => _accountCreationPageController.setLogin(login),
        decoration: blackInputDecorator('Login'),
      ),
    );
  }

  Container passwordLabel() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.all(5.0),
      child: const Text(
        'Password',
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
            _accountCreationPageController.validatePassword(password),
        onChanged: (password) =>
            _accountCreationPageController.setPassword(password),
        decoration: blackInputDecorator('Password'),
      ),
    );
  }

  Container repeatPasswordLabel() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.all(5.0),
      child: const Text(
        'Repeat password',
        style: TextStyle(fontSize: 18, color: Colors.black),
      ),
    );
  }

  Padding repeatPasswordTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        obscureText: true,
        keyboardType: TextInputType.text,
        validator: (password) =>
            _accountCreationPageController.validateRepeatedPassword(password),
        onChanged: (password) =>
            _accountCreationPageController.setRepeatedPassword(password),
        decoration: blackInputDecorator('Repeat password'),
      ),
    );
  }

  Padding submitButton() {
    return Padding(
        padding: const EdgeInsets.all(25.0),
        child: CustomButton(
          text: 'Create account',
          fontSize: 18,
          onPressed: () =>
              _accountCreationPageController.buttonValidator(context),
        ));
  }
}
