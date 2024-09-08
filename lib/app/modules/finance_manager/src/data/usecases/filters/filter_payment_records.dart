import '../../../domain/entities/expense.dart';
import '../../../domain/entities/income.dart';
import '../../../domain/entities/payment_method.dart';

import '../../../domain/entities/payment_record.dart';

import '../../../domain/entities/invoice.dart';
import '../../../domain/usecases/filters/filter_payment_records.dart';

class FilterPaymentRecordsImpl implements FilterPaymentRecords {
  @override
  List<PaymentRecord> byPaymentMethod({
    required List<PaymentRecord> records,
    required PaymentMethod paymentMethod,
  }) =>
      records.where((record) => record.paymentMethod == paymentMethod).toList();

  @override
  List<PaymentRecord> byType({
    required List<PaymentRecord> records,
    required PaymentRecordType type,
  }) {
    bool Function(PaymentRecord) isTheSpecifiedType =
        <PaymentRecordType, bool Function(PaymentRecord)>{
      PaymentRecordType.expense: (t) => t.paiyable is Expense,
      PaymentRecordType.income: (t) => t.paiyable is Income,
      PaymentRecordType.invoice: (t) => t.paiyable is Invoice,
    }[type]!;

    return records.where(isTheSpecifiedType).toList();
  }

  @override
  List<PaymentRecord> byValue({
    required List<PaymentRecord> records,
    required double value,
  }) =>
      records.where((record) => record.value >= value).toList();
}
