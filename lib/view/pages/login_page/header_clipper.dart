import 'package:flutter/rendering.dart';

/// Custom class of CustomClipper.
/// This can be used in ClipPath widget.
/// Path object specify how this widget will be painted
class LoginHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path()..lineTo(size.width, 0);

    path.quadraticBezierTo(size.width, size.height, 0, size.height);
    path.lineTo(0, 0);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
