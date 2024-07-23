import 'package:flutter/material.dart';

import '../../../domain/entities/category.dart';
import '../icons/category_icon.dart';
import '../layout/spaced.dart';
import '../texts/big_text.dart';
import '../texts/medium_text.dart';

class CategoryRow extends StatelessWidget {
  const CategoryRow({
    super.key,
    required this.category,
    this.padding,
  });

  final Category? category;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Spaced(
      padding: padding,
      first: const BigText("Categoria"),
      second: Row(
        children: [
          MediumText(category?.name ?? 'Indefinido'),
          const SizedBox(width: 12.0),
          CategoryIcon(
            iconName: category?.icon ?? 'icons/undefined.png',
            radius: 36.0,
          ),
        ],
      ),
    );
  }
}
