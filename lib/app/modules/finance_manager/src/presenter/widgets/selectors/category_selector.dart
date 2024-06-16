import 'package:flutter/material.dart';

import '../../../domain/entities/category.dart';
import '../icons/category_icon.dart';
import '../texts/small_text.dart';
import 'base_selectors.dart';

class CategorySelector extends StatelessWidget {
  const CategorySelector({
    super.key,
    required this.categories,
    required this.onSelected,
    required this.child,
  });

  final List<Category> categories;
  final void Function(Category) onSelected;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GridSelector<Category>(
      items: categories,
      itemsPerLine: 3,
      linesGap: 20.0,
      itemSize: 80.0,
      itemBuilder: (category) {
        return LimitedBox(
          maxWidth: 80.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CategoryIcon(iconName: category.icon, radius: 80.0),
              const SizedBox(height: 8.0),
              SmallText(
                category.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
      onItemTap: onSelected,
      child: child,
    );
  }
}
