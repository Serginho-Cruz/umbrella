import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../domain/entities/category.dart';
import '../../../domain/models/status.dart';
import '../../../domain/usecases/sorts/sort_expenses.dart';
import '../../controllers/finance_filterable_store.dart';
import '../../utils/adapt_name.dart';
import '../buttons/primary_button.dart';
import '../filters/category_filter.dart';
import '../filters/status_filter.dart';
import '../filters/range_value_filter.dart';
import '../layout/spaced.dart';
import '../texts/big_text.dart';
import '../texts/medium_text.dart';
import '../layout/dialog_layout.dart';

class FinanceFilterDialog extends StatefulWidget {
  const FinanceFilterDialog({
    super.key,
    required this.categories,
    required this.filterableStore,
  });

  final FinanceFilterableStore filterableStore;
  final List<Category> categories;

  @override
  State<FinanceFilterDialog> createState() => _FinanceFilterDialogState();
}

class _FinanceFilterDialogState extends State<FinanceFilterDialog> {
  @override
  Widget build(BuildContext context) {
    var (:min, :max) = widget.filterableStore.minAndMax;

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
              ...widget.categories.isNotEmpty
                  ? [
                      const BigText.bold('Categorias'),
                      Observer(
                        builder: (_) => CategoryFilter(
                          categories: widget.categories,
                          initiallySelected:
                              widget.filterableStore.filteredCategories,
                          onSelected: widget.filterableStore.toggleCategory,
                        ),
                      ),
                    ]
                  : [],
              const BigText.bold('Valor'),
              const SizedBox(height: 20.0),
              Observer(builder: (ctx) {
                (:min, :max) = widget.filterableStore.filteredRangeValue;

                var filteredRange = RangeValues(min, max);

                return RangeValueFilter(
                  range: filteredRange,
                  min: range.start,
                  max: range.end,
                  onNewRange: (newRange) {
                    widget.filterableStore.setMinValueRange(newRange.start);
                    widget.filterableStore.setMaxValueRange(newRange.end);
                  },
                );
              }),
              const Padding(
                padding: EdgeInsets.only(top: 18.0, bottom: 12.0),
                child: BigText.bold('Status'),
              ),
              StatusFilter(
                status: Status.values,
                selectedStatus: widget.filterableStore.filteredStatus,
                onStatusChanged: widget.filterableStore.toggleStatus,
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
                          onTap: () =>
                              widget.filterableStore.setSortOption(option),
                          child: Row(
                            children: [
                              Radio<PaiyableSortOption>.adaptive(
                                value: option,
                                groupValue: widget.filterableStore.sortOption,
                                onChanged: widget.filterableStore.setSortOption,
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
                  onTap: widget.filterableStore.toggleCrescentOrder,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const MediumText.bold('Ordenamento Crescente'),
                      Transform.scale(
                        scale: 1.2,
                        child: Checkbox.adaptive(
                          value: widget.filterableStore.isCrescentOrder,
                          onChanged: (_) {
                            widget.filterableStore.toggleCrescentOrder();
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
                  widget.filterableStore.filter();
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
