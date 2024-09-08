import '../../entities/payment_record.dart';

abstract interface class SortPaymentRecords {
  List<PaymentRecord> byValue({
    required List<PaymentRecord> records,
    bool isCrescent,
  });

  List<PaymentRecord> byPaymentDate({
    required List<PaymentRecord> records,
    bool isCrescent,
  });
  List<PaymentRecord> byID(List<PaymentRecord> records);
  List<PaymentRecord> revertSort(List<PaymentRecord> records);
}
