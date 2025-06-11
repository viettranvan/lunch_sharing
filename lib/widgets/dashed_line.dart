import 'package:flutter/material.dart';

class DashedLine extends StatelessWidget {
  final Axis direction;
  final double dashLength;
  final double dashGap;
  final Color color;
  final double thickness;
  final double radius;

  const DashedLine({
    super.key,
    this.direction = Axis.horizontal,
    this.dashLength = 5,
    this.dashGap = 3,
    this.color = Colors.grey,
    this.thickness = 2,
    this.radius = 4,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: direction == Axis.horizontal
          ? Size(double.infinity, thickness)
          : Size(thickness, double.infinity),
      painter: _DashedLinePainter(
        direction: direction,
        dashLength: dashLength,
        dashGap: dashGap,
        color: color,
        thickness: thickness,
        radius: radius,
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Axis direction;
  final double dashLength;
  final double dashGap;
  final Color color;
  final double thickness;
  final double radius;

  _DashedLinePainter({
    required this.direction,
    required this.dashLength,
    required this.dashGap,
    required this.color,
    required this.thickness,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    double start = 0;
    final totalLength = direction == Axis.horizontal ? size.width : size.height;

    while (start < totalLength) {
      final rect = direction == Axis.horizontal
          ? RRect.fromRectAndRadius(
              Rect.fromLTWH(start, 0, dashLength, thickness),
              Radius.circular(radius),
            )
          : RRect.fromRectAndRadius(
              Rect.fromLTWH(0, start, thickness, dashLength),
              Radius.circular(radius),
            );

      canvas.drawRRect(rect, paint);
      start += dashLength + dashGap;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
