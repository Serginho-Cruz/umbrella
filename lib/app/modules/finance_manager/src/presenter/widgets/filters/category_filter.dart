import 'package:flutter/material.dart';

import '../../../domain/entities/category.dart';
import '../icons/flippable_category_icon.dart';
import '../layout/horizontal_infinity_container.dart';
import '../layout/horizontal_listview.dart';

class CategoryFilter extends StatelessWidget {
  const CategoryFilter({
    super.key,
    required this.categories,
    required this.initiallySelected,
    required this.onSelected,
  });

  final List<Category> categories;
  final List<Category> initiallySelected;

  final void Function(Category) onSelected;

  @override
  Widget build(BuildContext context) {
    return HorizontallyInfinityContainer(
      noShadow: true,
      child: SizedBox(
        height: 200.0,
        child: HorizontalListView(
          itemCount: categories.length,
          itemCallback: (index) => Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: FlippableCategoryIcon(
              category: categories[index],
              initiallyFlipped: initiallySelected.contains(categories[index]),
              onFlip: () {
                onSelected(categories[index]);
              },
            ),
          ),
        ),
      ),
    );
  }
}
