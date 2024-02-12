import '../../entities/payment_method.dart';
import '../../entities/transaction.dart';

abstract class IFilterTransactions {
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

enum TransactionType { expense, income, invoice }
