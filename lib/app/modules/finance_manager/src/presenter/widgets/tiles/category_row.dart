import 'package:flutter/material.dart';

import '../../../domain/entities/category.dart';
import '../layout/spaced.dart';
import '../texts/big_text.dart';
import '../texts/medium_text.dart';

class CategoryRow extends StatelessWidget {
  const CategoryRow({
    super.key,
    required this.category,
    this.padding = EdgeInsets.zero,
  });

  final Category? category;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Spaced(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      first: const BigText("Categoria"),
      second: Row(
        children: [
          MediumText(category?.name ?? 'Indefinido'),
          Container(
            margin: const EdgeInsets.only(left: 12.0),
            height: 36.0,
            width: 36.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(width: 2),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(
                  category == null
                      ? 'assets/icons/undefined.png'
                      : 'assets/${category!.icon}',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
