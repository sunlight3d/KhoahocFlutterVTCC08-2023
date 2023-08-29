import 'package:flutter/material.dart';

class OvalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 5.0
      ..style = PaintingStyle.stroke;

    final redPaint = Paint()
      ..color = Colors.grey;

    final center = Offset(size.width / 2, size.height / 2);
    final radiusX = size.width / 2 - 0.9 * size.width;
    final radiusY = size.height / 2 - 0.9 * size.height;

    final path = Path()
      ..addOval(Rect.fromCenter(center: center, width: radiusX * 2, height: radiusY * 2));

    canvas.drawPath(path, strokePaint);

    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
        path,
      ),
      redPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}