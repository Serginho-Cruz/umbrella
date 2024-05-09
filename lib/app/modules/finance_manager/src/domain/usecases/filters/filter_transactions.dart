import '../../entities/payment_method.dart';
import '../../entities/transaction.dart';

abstract interface class FilterTransactions {
  List<Transaction> byType({
    required List<Transaction> transactions,
    required TransactionType type,
  });
  List<Transaction> byPaymentMethod({
    required List<Transaction> transactions,
    required PaymentMethod paymentMethod,
  });
  List<Transaction> byValue({
    required List<Transaction> transactions,
    required double value,
  });
}
