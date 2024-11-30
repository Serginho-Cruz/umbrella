import '../../entities/payment_record.dart';

enum PaymentRecordSortOption { byName, byValue, byPaymentDate }

abstract interface class SortPaymentRecords {
  List<PaymentRecord> byName({
    required List<PaymentRecord> records,
    bool isCrescent,
  });
  List<PaymentRecord> byValue({
    required List<PaymentRecord> records,
    bool isCrescent,
  });
  List<PaymentRecord> byPaymentDate({
    required List<PaymentRecord> records,
    bool isCrescent,
  });
}
