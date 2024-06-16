import 'dart:math' show pow;
import 'package:flutter/material.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/layout/horizontal_infinity_container.dart';

import '../../../domain/entities/category.dart';
import '../../../domain/models/finance_model.dart';
import '../../../utils/currency_format.dart';
import '../../../utils/umbrella_sizes.dart';
import '../buttons/primary_button.dart';
import '../icons/category_icon.dart';
import '../layout/horizontal_listview.dart';
import '../layout/spaced.dart';
import '../texts/big_text.dart';
import '../texts/medium_text.dart';
import 'dialog_layout.dart';

class PaiyableFilterDialog extends StatefulWidget {
  const PaiyableFilterDialog({
    super.key,
    required this.categories,
    required this.selectedValues,
    required this.minAndMaxValues,
    required this.filteredCategories,
  });

  final List<Category> categories;
  final List<Category> filteredCategories;
  final RangeValues selectedValues;
  final RangeValues minAndMaxValues;

  @override
  State<PaiyableFilterDialog> createState() => _PaiyableFilterDialogState();
}

class _PaiyableFilterDialogState extends State<PaiyableFilterDialog> {
  late RangeValues values;
  late double minValue, maxValue;

  final List<Status> filteredStatus = [];
  PaiyableSortOption? sortOption;

  @override
  void initState() {
    super.initState();
    values = _roundTo10Exponent(widget.selectedValues);
    var rounded = _roundTo10Exponent(widget.minAndMaxValues);

    minValue = rounded.start;
    maxValue = rounded.end;
  }

  @override
  Widget build(BuildContext context) {
    return DialogLayout(
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
              const BigText.bold('Categorias'),
              HorizontallyInfinityContainer(
                noShadow: true,
                child: SizedBox(
                  height: 200.0,
                  child: HorizontalListView(
                    itemCount: widget.categories.length,
                    itemCallback: (index) => Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CategoryIcon(
                              iconName: widget.categories[index].icon,
                              radius: 70.0),
                          const SizedBox(height: 10.0),
                          MediumText(widget.categories[index].name),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const BigText.bold('Valor'),
              const SizedBox(height: 20.0),
              Align(
                alignment: Alignment.center,
                child: Text.rich(
                  TextSpan(
                    style: const TextStyle(fontSize: UmbrellaSizes.medium),
                    children: [
                      const TextSpan(text: 'De '),
                      TextSpan(
                        text: CurrencyFormat.format(values.start),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(text: ' até '),
                      TextSpan(
                        text: CurrencyFormat.format(values.end),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  maxLines: 1,
                ),
              ),
              RangeSlider(
                values: values,
                min: minValue,
                max: maxValue,
                labels: RangeLabels(
                  'De ${CurrencyFormat.format(values.start)}',
                  'Até ${CurrencyFormat.format(values.end)}',
                ),
                onChanged: (newValues) {
                  setState(() => values = _roundTo10Divisor(newValues));
                },
              ),
              const Padding(
                padding: EdgeInsets.only(top: 18.0, bottom: 12.0),
                child: BigText.bold('Status'),
              ),
              ...Status.values.map(
                (s) => Row(
                  children: [
                    Checkbox.adaptive(
                      value: filteredStatus.contains(s),
                      onChanged: (newValue) {
                        filteredStatus.contains(s)
                            ? filteredStatus.remove(s)
                            : filteredStatus.add(s);

                        setState(() {});
                      },
                    ),
                    MediumText(s.adaptedName),
                  ],
                ),
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
              const SizedBox(height: 40.0),
              PrimaryButton(
                label: const BigText.bold('Aplicar'),
                width: MediaQuery.sizeOf(context).width,
                height: 70.0,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  RangeValues _roundTo10Divisor(RangeValues range) {
    double min = range.start;
    double max = range.end;

    min = (min / 10).roundToDouble() * 10;
    max = (max / 10).roundToDouble() * 10;

    return RangeValues(min, max);
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

enum PaiyableSortOption { byValue, byName, byDueDate }

extension on PaiyableSortOption {
  String get adaptedName => switch (this) {
        PaiyableSortOption.byName => 'Nome',
        PaiyableSortOption.byDueDate => 'Data de Vencimento',
        PaiyableSortOption.byValue => 'Valor',
      };
}
