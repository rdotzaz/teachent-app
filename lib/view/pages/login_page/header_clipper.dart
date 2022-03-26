import 'package:flutter/rendering.dart';

class LoginHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path()..lineTo(size.width, 0);
    var point1 = Offset(size.width, size.height);
    var point2 = Offset(0, size.height);

    path.quadraticBezierTo(point1.dx, point1.dy, point2.dx, point2.dy);
    path.lineTo(0, 0);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
