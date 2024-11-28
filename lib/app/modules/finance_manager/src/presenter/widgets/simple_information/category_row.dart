import 'package:flutter/material.dart';

import '../../../domain/entities/category.dart';
import '../../utils/umbrella_sizes.dart';
import '../icons/category_icon.dart';
import '../layout/spaced.dart';

class CategoryRow extends StatelessWidget {
  const CategoryRow({
    super.key,
    required this.category,
    this.padding,
    this.textSize = UmbrellaSizes.medium,
    this.iconSize = 36.0,
  });

  final Category? category;
  final EdgeInsetsGeometry? padding;
  final double textSize;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Spaced(
      padding: padding,
      first: Text(
        "Categoria",
        style: TextStyle(fontSize: textSize),
      ),
      second: Row(
        children: [
          Text(
            category?.name ?? 'Indefinido',
            style: TextStyle(fontSize: textSize),
          ),
          const SizedBox(width: 12.0),
          CategoryIcon(
            iconName: category?.icon ?? 'undefined.png',
            radius: iconSize,
          ),
        ],
      ),
    );
  }
}
