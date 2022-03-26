import 'package:flutter/material.dart';

class ProfileButton extends StatelessWidget {
  final String profile;
  final IconData icon;
  final void Function() onPressed;
  final MaterialColor color;
  const ProfileButton(
      {Key? key,
      required this.profile,
      required this.icon,
      required this.onPressed,
      required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15.0),
      child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(color[100]!),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)))),
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 75, color: color),
                  Text(profile, style: TextStyle(fontSize: 18, color: color))
                ],
              )),
          onPressed: onPressed),
    );
  }
}
