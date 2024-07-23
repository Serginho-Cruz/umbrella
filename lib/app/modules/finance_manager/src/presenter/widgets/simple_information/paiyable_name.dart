import 'package:flutter/material.dart';
import '../../../domain/models/paiyable_model.dart';
import '../../utils/resolve_paiyable_name.dart';
import '../texts/medium_text.dart';

class PaiyableName extends StatelessWidget {
  const PaiyableName({super.key, required this.model});

  final PaiyableModel model;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MediumText(resolvePaiyableTypeName(model)),
        const SizedBox(width: 10.0),
        MediumText.bold(resolvePaiyableName(model)),
      ],
    );
  }
}
