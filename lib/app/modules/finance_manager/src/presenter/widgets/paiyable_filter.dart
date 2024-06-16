import 'package:flutter/material.dart';

import '../../domain/entities/category.dart';
import 'buttons/filter_button.dart';
import 'dialogs/paiyable_filter_dialog.dart';
import 'umbrella_search_bar.dart';

class PaiyableFilter extends StatelessWidget {
  const PaiyableFilter({
    super.key,
    required this.filterName,
    required this.categories,
    required this.filteredCategories,
    required this.minValue,
    required this.maxValue,
    required this.filteredValues,
  });

  final void Function(String) filterName;

  final List<Category> categories;
  final List<Category> filteredCategories;

  final double minValue;
  final double maxValue;

  final (double, double) filteredValues;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        UmbrellaSearchBar(
          searchFunction: filterName,
          width: MediaQuery.sizeOf(context).width * 0.9 - 75.0,
          height: 50.0,
        ),
        FilterButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (ctx) => PaiyableFilterDialog(
                categories: categories,
                filteredCategories: filteredCategories,
                selectedValues: RangeValues(
                  filteredValues.$1,
                  filteredValues.$2,
                ),
                minAndMaxValues: RangeValues(minValue, maxValue),
              ),
            );
          },
        ),
      ],
    );
  }
}
