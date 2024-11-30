import '../../entities/date.dart';
import '../../entities/payment_method.dart';
import '../../entities/payment_record.dart';

enum PaymentRecordType { expense, income, invoice }

abstract interface class FilterPaymentRecords {
  List<PaymentRecord> byName({
    required List<PaymentRecord> records,
    required String name,
  });
  List<PaymentRecord> byType({
    required List<PaymentRecord> records,
    required PaymentRecordType? type,
  });
  List<PaymentRecord> byPaymentMethods({
    required List<PaymentRecord> records,
    required List<PaymentMethod> paymentMethods,
  });
  List<PaymentRecord> byValueRange({
    required List<PaymentRecord> records,
    required double minValue,
    required double maxValue,
  });
  List<PaymentRecord> byDateRange({
    required List<PaymentRecord> records,
    required Date minDate,
    required Date maxDate,
  });
}
