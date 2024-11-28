import 'package:flutter/material.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/stores/finance_filterable_store.dart';

import '../../../domain/entities/category.dart';
import '../buttons/filter_button.dart';
import '../dialogs/finance_filter_dialog.dart';
import 'umbrella_search_bar.dart';

class FinanceFilter extends StatelessWidget {
  const FinanceFilter({
    super.key,
    required this.categories,
    required this.filterableStore,
  });

  final List<Category> categories;
  final FinanceFilterableStore filterableStore;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        UmbrellaSearchBar(
          onSubmitted: filterableStore.setFilterName,
          onChanged: filterableStore.setFilterName,
          width: MediaQuery.sizeOf(context).width * 0.9 - 75.0,
          height: 50.0,
        ),
        FilterButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (ctx) => FinanceFilterDialog(
                categories: categories,
                filterableStore: filterableStore,
              ),
            );
          },
        ),
      ],
    );
  }
}
