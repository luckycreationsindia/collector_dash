import 'package:flutter/material.dart';

class Player extends CustomPainter {
  final Offset offset;

  Player({super.repaint, required this.offset});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(
      offset,
      6,
      Paint()
        ..style = PaintingStyle.fill
        ..color = Colors.red[900]!
        ..colorFilter = const ColorFilter.srgbToLinearGamma(),
    );
  }

  /// Since this is a static drawing, we set this to false
  @override
  bool shouldRepaint(Player oldDelegate) => oldDelegate.offset != offset;
}
