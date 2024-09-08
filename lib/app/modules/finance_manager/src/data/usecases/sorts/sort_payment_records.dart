import '../../../domain/entities/payment_record.dart';
import '../../../domain/usecases/sorts/sort_payment_records.dart';

class SortPaymentRecordsImpl implements SortPaymentRecords {
  @override
  List<PaymentRecord> byID(List<PaymentRecord> records) =>
      List.from(records)..sort((a, b) => a.id.compareTo(b.id));

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
  List<PaymentRecord> revertSort(List<PaymentRecord> records) =>
      records.reversed.toList();

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
