import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:umbrella_echonomics/app/modules/bind_service_provider.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/stores/month_store.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/utils/adapt_name.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/presenter/widgets/buttons/segmented_sort_button.dart';

import '../../../domain/usecases/sorts/sort_payment_records.dart';
import '../../stores/payment_record_store.dart';
import '../buttons/primary_button.dart';
import '../buttons/segmented_origin_button.dart';
import '../filters/date_range_filter.dart';
import '../filters/payment_method_filter.dart';
import '../filters/range_value_filter.dart';
import '../layout/dialog_layout.dart';
import '../layout/spaced.dart';
import '../texts/big_text.dart';
import '../texts/medium_text.dart';

class PaymentRecordFilterDialog extends StatelessWidget {
  const PaymentRecordFilterDialog({super.key, required this.recordStore});

  final PaymentRecordStore recordStore;

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
              const BigText.bold('Origem'),
              Observer(
                builder: (_) => SegmentedOriginButton(
                  selected: recordStore.filteredOrigin,
                  onChanged: recordStore.setOriginFilter,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 18.0, bottom: 12),
                child: BigText.bold('Valor'),
              ),
              Observer(builder: (_) {
                var (:min, :max) = recordStore.minAndMax;

                if (recordStore.minValueRange < min ||
                    recordStore.minValueRange > max) {
                  recordStore.setMinValue(min);
                }

                if (recordStore.maxValueRange < min ||
                    recordStore.maxValueRange > max) {
                  recordStore.setMaxValue(max);
                }
                return RangeValueFilter(
                  max: max,
                  min: min,
                  onNewRange: (range) {
                    var minRange = range.start, maxRange = range.end;

                    recordStore.setMinValue(minRange);
                    recordStore.setMaxValue(maxRange);
                  },
                  range: RangeValues(
                    recordStore.minValueRange,
                    recordStore.maxValueRange,
                  ),
                );
              }),
              const Padding(
                padding: EdgeInsets.only(top: 18.0, bottom: 12),
                child: BigText.bold('Data'),
              ),
              Observer(
                builder: (_) {
                  var (:month, :year) =
                      BindServiceProvider.get<MonthStore>().month;

                  return DateRangeFilter(
                    minDate: recordStore.firstDateRange,
                    maxDate: recordStore.lastDateRange,
                    month: month,
                    year: year,
                    onChanged: (minDate, maxDate) {
                      recordStore.setMinDate(minDate);
                      recordStore.setMaxDate(maxDate);
                    },
                  );
                },
              ),
              const Padding(
                padding: EdgeInsets.only(top: 18.0, bottom: 12),
                child: BigText.bold('Forma de Pagamento'),
              ),
              Observer(
                builder: (_) => PaymentMethodFilter(
                  initiallySelected:
                      recordStore.filteredMethods.nonObservableInner,
                  onTapped: recordStore.togglePaymentMethod,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 18.0, bottom: 12),
                child: BigText.bold('Ordem das datas dos registros'),
              ),
              Observer(
                builder: (_) => SegmentedSortButton(
                  isCrescentOrder: recordStore.areDatesInCrescentOrder,
                  onChanged: recordStore.setDatesCrescentOrder,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 18.0, bottom: 12),
                child: BigText.bold('Ordem dos registros'),
              ),
              Observer(
                builder: (_) => Wrap(
                  direction: Axis.vertical,
                  children: PaymentRecordSortOption.values.map((option) {
                    return GestureDetector(
                      onTap: () => recordStore.setSortOption(option),
                      child: Row(
                        children: [
                          Radio.adaptive(
                            value: option,
                            groupValue: recordStore.sortOption,
                            onChanged: (newOption) {
                              if (newOption != null) {
                                recordStore.setSortOption(newOption);
                              }
                            },
                          ),
                          MediumText(adaptRecordsOptionName(option)),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              PrimaryButton(
                height: 60,
                width: MediaQuery.sizeOf(context).width,
                label: const MediumText.bold('Aplicar'),
                onPressed: () {
                  recordStore.filter();
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
