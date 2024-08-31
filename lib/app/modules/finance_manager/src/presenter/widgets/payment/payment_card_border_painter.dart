import 'package:flutter/material.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/payment_method.dart';

class PaymentCardBorderPainter extends CustomPainter {
  final PaymentMethod method;
  final double borderRadius;

  PaymentCardBorderPainter({
    super.repaint,
    required this.method,
    this.borderRadius = 12.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    //Border

    Path path = Path();

    Paint stroke = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    path.moveTo(size.width * 0.35, 0.00);
    path.lineTo(0 + borderRadius, 0.00);

    drawBorder(path, 0, 0 + borderRadius);

    path.lineTo(0, size.height - borderRadius);

    drawBorder(path, 0 + borderRadius, size.height);

    path.lineTo(size.width - borderRadius, size.height);

    drawBorder(path, size.width, size.height - borderRadius);

    path.lineTo(size.width, 0.00 + borderRadius);

    drawBorder(path, size.width - borderRadius, 0.00);

    path.lineTo(size.width * 0.65, 0.00);

    canvas.drawPath(path, stroke);

    final textPivot = Offset(size.width * 0.35, -8);

    TextPainter text = TextPainter(
      text: TextSpan(
        text: method.name,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout(maxWidth: size.width * 0.3, minWidth: size.width * 0.3);

    text.paint(canvas, textPivot);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  void drawBorder(Path path, double destinyX, double destinyY) {
    if (borderRadius > 0.00) {
      path.arcToPoint(
        Offset(destinyX, destinyY),
        clockwise: false,
        radius: Radius.circular(borderRadius),
      );
    }
  }
}
