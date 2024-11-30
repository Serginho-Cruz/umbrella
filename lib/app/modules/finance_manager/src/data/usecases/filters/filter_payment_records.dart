import '../../../domain/entities/date.dart';
import '../../../domain/entities/expense.dart';
import '../../../domain/entities/income.dart';
import '../../../domain/entities/payment_method.dart';

import '../../../domain/entities/payment_record.dart';

import '../../../domain/entities/invoice.dart';
import '../../../domain/usecases/filters/filter_payment_records.dart';

class FilterPaymentRecordsImpl implements FilterPaymentRecords {
  @override
  List<PaymentRecord> byName({
    required List<PaymentRecord> records,
    required String name,
  }) {
    if (name.isEmpty) return records;
    bool Function(PaymentRecord) hasName = switch (records) {
      <PaymentRecord<Expense>>[] => (r) =>
          (r.paiyable as Expense).name.contains(name),
      <PaymentRecord<Income>>[] => (r) =>
          (r.paiyable as Income).name.contains(name),
      <PaymentRecord<Invoice>>[] => (r) =>
          (r.paiyable as Invoice).card.name.contains(name),
      _ => (_) => false,
    };

    return records.where(hasName).toList();
  }

  @override
  List<PaymentRecord> byPaymentMethods({
    required List<PaymentRecord> records,
    required List<PaymentMethod> paymentMethods,
  }) {
    if (paymentMethods.isEmpty) return records;
    return records
        .where((record) => paymentMethods.contains(record.paymentMethod))
        .toList();
  }

  @override
  List<PaymentRecord> byType({
    required List<PaymentRecord> records,
    required PaymentRecordType? type,
  }) {
    if (type == null) return records;

    bool Function(PaymentRecord) isTheSpecifiedType = switch (type) {
      PaymentRecordType.expense => (t) => t.paiyable is Expense,
      PaymentRecordType.income => (t) => t.paiyable is Income,
      PaymentRecordType.invoice => (t) => t.paiyable is Invoice,
    };

    return records.where(isTheSpecifiedType).toList();
  }

  @override
  List<PaymentRecord> byValueRange({
    required List<PaymentRecord> records,
    required double minValue,
    required double maxValue,
  }) {
    if (minValue == 0 && maxValue == 0) return records;
    return records
        .where((record) => record.value >= minValue && record.value <= maxValue)
        .toList();
  }

  @override
  List<PaymentRecord> byDateRange({
    required List<PaymentRecord> records,
    required Date minDate,
    required Date maxDate,
  }) =>
      records
          .where((record) =>
              (record.date.isAfter(minDate) && record.date.isBefore(maxDate)) ||
              record.date == minDate ||
              record.date == maxDate)
          .toList();
}
