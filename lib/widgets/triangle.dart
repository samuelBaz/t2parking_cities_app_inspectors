import 'package:flutter/material.dart';

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(size.width / 2, 0); // Punto superior central (pico)
    path.lineTo(size.width, size.height); // Punto inferior derecho
    path.lineTo(0, size.height); // Punto inferior izquierdo
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}