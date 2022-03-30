import 'package:flutter/material.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';

class AccountCreationPage extends StatelessWidget {
  final DatabaseObject dbObject;
  const AccountCreationPage(this.dbObject, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellow,
    );
  }
}
