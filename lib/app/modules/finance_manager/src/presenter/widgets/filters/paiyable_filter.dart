import 'package:flutter/material.dart';

import '../../../domain/entities/category.dart';
import '../../../domain/models/finance_model.dart';
import '../../../domain/usecases/orders/order_expenses.dart';
import '../buttons/filter_button.dart';
import '../dialogs/paiyable_filter_dialog.dart';
import 'umbrella_search_bar.dart';

class PaiyableFilter<T extends FinanceModel> extends StatelessWidget {
  const PaiyableFilter({
    super.key,
    required this.filterName,
    required this.categories,
    this.filteredCategories = const [],
    required this.minValue,
    required this.maxValue,
    required this.filteredValues,
    required this.filterByCategory,
    required this.filterByValue,
    required this.filterByStatus,
    required this.sort,
    this.filteredStatus = const [],
    this.sortOption,
    required this.onFiltersApplied,
    required this.models,
  });

  final List<T> models;

  final List<T> Function(
    List<T> list,
    List<Category> categories,
  ) filterByCategory;

  final List<T> Function(List<T> list, double min, double max) filterByValue;
  final List<T> Function(List<T> list, List<Status> status) filterByStatus;
  final List<T> Function(
    List<T> list,
    PaiyableSortOption option,
    bool isCrescent,
  ) sort;

  final void Function(List<T> list) onFiltersApplied;

  final void Function(String) filterName;

  final List<Category> categories;
  final List<Category> filteredCategories;

  final double minValue;
  final double maxValue;

  final (double, double) filteredValues;
  final List<Status> filteredStatus;
  final PaiyableSortOption? sortOption;

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
                onFiltersApplied: _filter,
                categories: categories,
                filteredCategories: filteredCategories,
                selectedValues: RangeValues(
                  filteredValues.$1,
                  filteredValues.$2,
                ),
                minAndMaxValues: RangeValues(minValue, maxValue),
                statusFiltered: filteredStatus,
                sortOption: sortOption,
              ),
            );
          },
        ),
      ],
    );
  }

  void _filter({
    required List<Category> categories,
    required RangeValues range,
    required List<Status> filteredStatus,
    required PaiyableSortOption? sortOption,
    required bool crescentSort,
  }) {
    var list = List.of(models);

    list = filterByCategory(list, categories);

    list = filterByValue(list, range.start, range.end);

    list = filterByStatus(list, filteredStatus);

    list = sort(list, sortOption ?? PaiyableSortOption.byDueDate, crescentSort);

    onFiltersApplied(list);
  }
}
