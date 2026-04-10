import 'package:flutter/material.dart';

class DoubleArrowIcon extends StatelessWidget {
  final double size;
  final Color color;

  const DoubleArrowIcon({super.key, this.size = 24, this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size / 2),
      painter: _DoubleArrowPainter(color),
    );
  }
}

class _DoubleArrowPainter extends CustomPainter {
  final Color color;

  _DoubleArrowPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final arrowHeadSize = 6.0;

    final startX = size.width * 0.05;
    final endX = size.width * 0.95;
    final centerY = size.height / 2;

    // Draw straight line
    canvas.drawLine(
      Offset(startX, centerY),
      Offset(endX, centerY),
      paint,
    );

    // Left arrow head
    canvas.drawLine(
      Offset(startX, centerY),
      Offset(startX + arrowHeadSize, centerY - arrowHeadSize),
      paint,
    );
    canvas.drawLine(
      Offset(startX, centerY),
      Offset(startX + arrowHeadSize, centerY + arrowHeadSize),
      paint,
    );

    // Right arrow head
    canvas.drawLine(
      Offset(endX, centerY),
      Offset(endX - arrowHeadSize, centerY - arrowHeadSize),
      paint,
    );
    canvas.drawLine(
      Offset(endX, centerY),
      Offset(endX - arrowHeadSize, centerY + arrowHeadSize),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
