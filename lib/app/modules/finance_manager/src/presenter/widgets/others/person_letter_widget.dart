import 'package:flutter/material.dart';

import '../../utils/currency_format.dart';
import '../../utils/umbrella_palette.dart';
import '../texts/medium_text.dart';
import '../texts/small_text.dart';

class PersonLetterWidget extends StatelessWidget {
  final String personStatus;
  final String personName;
  final double value;
  final Color valueColor;

  const PersonLetterWidget({
    super.key,
    required this.personStatus,
    required this.personName,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            border:
                Border.all(width: 2, color: UmbrellaPalette.letterBorderColor),
            color: UmbrellaPalette.letterColor,
            borderRadius: BorderRadius.circular(4),
          ),
          width: 250,
          height: 140,
          child: CustomPaint(
            painter: EnvelopePainter(),
          ),
        ),
        Positioned(
          top: 200 / 8,
          left: 0,
          right: 0,
          child: MediumText.bold(personStatus, textAlign: TextAlign.center),
        ),
        Positioned(
          bottom: 10,
          left: 10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SmallText('Nome: $personName'),
              SmallText(
                'Valor: ${CurrencyFormat.format(value)}',
                color: valueColor,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class EnvelopePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = UmbrellaPalette.letterBorderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width * 0.5, size.height * 0.5);
    path.lineTo(size.width, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
