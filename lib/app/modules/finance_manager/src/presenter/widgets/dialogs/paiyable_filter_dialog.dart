import 'dart:math' show pow;
import 'package:flutter/material.dart';

import '../../../domain/entities/category.dart';
import '../../../domain/models/finance_model.dart';
import '../../../domain/models/status.dart';
import '../../../domain/usecases/orders/order_expenses.dart';
import '../buttons/primary_button.dart';
import '../filters/category_filter.dart';
import '../filters/paiyable_status_filter.dart';
import '../filters/range_value_filter.dart';
import '../layout/spaced.dart';
import '../texts/big_text.dart';
import '../texts/medium_text.dart';
import 'dialog_layout.dart';

class PaiyableFilterDialog<T extends FinanceModel> extends StatefulWidget {
  const PaiyableFilterDialog({
    super.key,
    required this.categories,
    required this.selectedValues,
    required this.minAndMaxValues,
    this.filteredCategories = const [],
    this.statusFiltered = const [],
    this.sortOption,
    this.onFiltersApplied,
  });

  final void Function({
    required List<Category> categories,
    required RangeValues range,
    required List<Status> filteredStatus,
    required PaiyableSortOption? sortOption,
    required bool crescentSort,
  })? onFiltersApplied;

  final List<Category> categories;
  final List<Category> filteredCategories;
  final RangeValues selectedValues;
  final RangeValues minAndMaxValues;
  final PaiyableSortOption? sortOption;
  final List<Status> statusFiltered;

  @override
  State<PaiyableFilterDialog> createState() => _PaiyableFilterDialogState();
}

class _PaiyableFilterDialogState extends State<PaiyableFilterDialog> {
  late RangeValues values;
  late double minValue, maxValue;

  final List<Category> selectedCategories = [];
  final List<Status> selectedStatus = [];
  PaiyableSortOption? sortOption;

  bool crescentSort = true;

  @override
  void initState() {
    super.initState();
    values = _roundTo10Exponent(widget.selectedValues);
    var rounded = _roundTo10Exponent(widget.minAndMaxValues);

    minValue = rounded.start;
    maxValue = rounded.end;

    selectedCategories.addAll(widget.filteredCategories);
    selectedStatus.addAll(widget.statusFiltered);

    sortOption = widget.sortOption;
  }

  @override
  Widget build(BuildContext context) {
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
                      CategoryFilter(
                        categories: widget.categories,
                        initiallySelected: widget.filteredCategories,
                        onSelected: (cat) {
                          selectedCategories.contains(cat)
                              ? selectedCategories.remove(cat)
                              : selectedCategories.add(cat);
                        },
                      ),
                    ]
                  : [],
              const BigText.bold('Valor'),
              const SizedBox(height: 20.0),
              RangeValueFilter(
                range: values,
                min: minValue,
                max: maxValue,
                onNewRange: (newValues) {
                  setState(() => values = newValues);
                },
              ),
              const Padding(
                padding: EdgeInsets.only(top: 18.0, bottom: 12.0),
                child: BigText.bold('Status'),
              ),
              PaiyableStatusFilter(
                status: Status.values,
                selectedStatus: selectedStatus,
                onStatusChanged: (status) {
                  selectedStatus.contains(status)
                      ? selectedStatus.remove(status)
                      : selectedStatus.add(status);

                  setState(() {});
                },
              ),
              const Padding(
                padding: EdgeInsets.only(top: 18.0, bottom: 12.0),
                child: BigText.bold('Ordenar Por'),
              ),
              ...PaiyableSortOption.values.map(
                (option) => Row(
                  children: [
                    Radio<PaiyableSortOption>.adaptive(
                      value: option,
                      groupValue: sortOption,
                      onChanged: (newOption) {
                        setState(() => sortOption = newOption);
                      },
                    ),
                    MediumText(option.adaptedName),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  setState(() => crescentSort = !crescentSort);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const MediumText.bold('Ordenamento Crescente'),
                    Transform.scale(
                      scale: 1.2,
                      child: Checkbox.adaptive(
                        value: crescentSort,
                        onChanged: (newValue) {
                          setState(() {
                            crescentSort = newValue!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40.0),
              PrimaryButton(
                label: const BigText.bold('Aplicar'),
                width: MediaQuery.sizeOf(context).width,
                height: 60.0,
                onPressed: () {
                  widget.onFiltersApplied?.call(
                    categories: selectedCategories,
                    filteredStatus: selectedStatus,
                    range: values,
                    sortOption: sortOption,
                    crescentSort: crescentSort,
                  );
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  RangeValues _roundTo10Exponent(RangeValues range) {
    double min = range.start;
    double max = range.end;

    int minPlaces = 0, maxPlaces = 0;

    while (min > 9.0) {
      min /= 10;
      minPlaces++;
    }

    while (max > 9.0) {
      max /= 10;
      maxPlaces++;
    }

    min = min.floorToDouble() * pow(10, minPlaces);
    max = max.ceilToDouble() * pow(10, maxPlaces);

    return RangeValues(min, max);
  }
}

extension on PaiyableSortOption {
  String get adaptedName => switch (this) {
        PaiyableSortOption.byName => 'Nome',
        PaiyableSortOption.byDueDate => 'Data de Vencimento',
        PaiyableSortOption.byValue => 'Valor',
      };
}
