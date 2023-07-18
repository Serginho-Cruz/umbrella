import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/payment_method.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/transaction.dart';

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
