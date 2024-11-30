import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/paiyable.dart';

import '../../../domain/entities/expense.dart';
import '../../../domain/entities/income.dart';
import '../../../domain/entities/payment_record.dart';
import '../../../domain/usecases/sorts/sort_payment_records.dart';

class SortPaymentRecordsImpl implements SortPaymentRecords {
  @override
  List<PaymentRecord> byValue({
    required List<PaymentRecord> records,
    bool isCrescent = true,
  }) =>
      _sortList(
        sortFunction: (a, b) => a.value.compareTo(b.value),
        records: records,
        isCrescent: isCrescent,
      );
  @override
  List<PaymentRecord> byPaymentDate({
    required List<PaymentRecord> records,
    bool isCrescent = true,
  }) =>
      _sortList(
        sortFunction: (a, b) => a.date.compareTo(b.date),
        records: records,
        isCrescent: isCrescent,
      );

  @override
  List<PaymentRecord<Paiyable>> byName({
    required List<PaymentRecord<Paiyable>> records,
    bool isCrescent = true,
  }) {
    int Function(PaymentRecord, PaymentRecord) sort;

    sort = switch (records) {
      <PaymentRecord<Income>>[] => (a, b) =>
          (a.paiyable as Income).name.compareTo((b.paiyable as Income).name),
      <PaymentRecord<Expense>>[] => (a, b) =>
          (a.paiyable as Expense).name.compareTo((b.paiyable as Expense).name),
      _ => (a, b) => a.date.compareTo(b.date),
    };

    return _sortList(
      sortFunction: sort,
      records: records,
      isCrescent: isCrescent,
    );
  }

  List<PaymentRecord> _sortList({
    required int Function(PaymentRecord, PaymentRecord) sortFunction,
    required List<PaymentRecord> records,
    required bool isCrescent,
  }) {
    //Multiplier Number in compare will order the list in crescent or decrescent
    //without using .reverse in the final of processing, saving cellphone resources
    int multiplierNumber = isCrescent ? 1 : -1;
    return List.from(records)
      ..sort((a, b) => sortFunction(a, b) * multiplierNumber);
  }
}
