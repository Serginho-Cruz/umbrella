import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../domain/entities/category.dart';
import '../../../domain/models/status.dart';
import '../../../domain/usecases/sorts/sort_expenses.dart';
import '../../stores/finance_filterable_store.dart';
import '../../utils/adapt_name.dart';
import '../../utils/umbrella_palette.dart';
import '../buttons/primary_button.dart';
import '../filters/category_filter.dart';
import '../filters/status_filter.dart';
import '../filters/range_value_filter.dart';
import '../layout/spaced.dart';
import '../texts/big_text.dart';
import '../texts/medium_text.dart';
import '../layout/dialog_layout.dart';

class FinanceFilterDialog extends StatelessWidget {
  const FinanceFilterDialog({
    super.key,
    required this.categories,
    required this.filterableStore,
  });

  final FinanceFilterableStore filterableStore;
  final List<Category> categories;

  @override
  Widget build(BuildContext context) {
    var (:min, :max) = filterableStore.minAndMax;

    final RangeValues range = RangeValues(min, max);

    return DialogLayout(
      fullscreen: true,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 30.0),
                child: Spaced(
                  first: const Text(
                    'Filtros',
                    style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  second: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Icon(Icons.close, size: 30.0),
                    ),
                  ),
                ),
              ),
              ...categories.isNotEmpty
                  ? [
                      const BigText.bold('Categorias'),
                      Observer(
                        builder: (_) => CategoryFilter(
                          categories: categories,
                          initiallySelected: filterableStore.filteredCategories,
                          onSelected: filterableStore.toggleCategory,
                        ),
                      ),
                    ]
                  : [],
              const BigText.bold('Valor'),
              const SizedBox(height: 20.0),
              Observer(builder: (ctx) {
                (:min, :max) = filterableStore.filteredRangeValue;

                var filteredRange = RangeValues(min, max);

                return RangeValueFilter(
                  range: filteredRange,
                  min: range.start,
                  max: range.end,
                  onNewRange: (newRange) {
                    filterableStore.setMinValueRange(newRange.start);
                    filterableStore.setMaxValueRange(newRange.end);
                  },
                );
              }),
              const Padding(
                padding: EdgeInsets.only(top: 18.0, bottom: 12.0),
                child: BigText.bold('Status'),
              ),
              StatusFilter(
                status: Status.values,
                selectedStatus: filterableStore.filteredStatus,
                onStatusChanged: filterableStore.toggleStatus,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 18.0, bottom: 12.0),
                child: BigText.bold('Ordenar Por'),
              ),
              Observer(
                builder: (_) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: PaiyableSortOption.values
                      .map(
                        (option) => GestureDetector(
                          onTap: () => filterableStore.setSortOption(option),
                          child: Row(
                            children: [
                              Radio<PaiyableSortOption>.adaptive(
                                value: option,
                                activeColor: UmbrellaPalette.sliderFilterColor,
                                groupValue: filterableStore.sortOption,
                                onChanged: filterableStore.setSortOption,
                              ),
                              MediumText(adaptSortOptionName(option)),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 20),
              Observer(
                builder: (_) => GestureDetector(
                  onTap: filterableStore.toggleCrescentOrder,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const MediumText.bold('Ordenamento Crescente'),
                      Transform.scale(
                        scale: 1.2,
                        child: Checkbox.adaptive(
                          value: filterableStore.isCrescentOrder,
                          activeColor: UmbrellaPalette.sliderFilterColor,
                          onChanged: (_) {
                            filterableStore.toggleCrescentOrder();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40.0),
              PrimaryButton(
                label: const BigText.bold('Aplicar'),
                width: MediaQuery.sizeOf(context).width,
                height: 60.0,
                onPressed: () {
                  filterableStore.filter();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
