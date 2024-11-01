import '../../entities/payment_method.dart';
import '../../entities/payment_record.dart';

enum PaymentRecordType { expense, income, invoice }

abstract interface class FilterPaymentRecords {
  List<PaymentRecord> byType({
    required List<PaymentRecord> records,
    required PaymentRecordType type,
  });
  List<PaymentRecord> byPaymentMethod({
    required List<PaymentRecord> records,
    required PaymentMethod paymentMethod,
  });
  List<PaymentRecord> byValue({
    required List<PaymentRecord> records,
    required double value,
  });
}
