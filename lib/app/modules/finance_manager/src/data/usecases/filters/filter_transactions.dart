import '../../../domain/entities/expense.dart';
import '../../../domain/entities/income.dart';
import '../../../domain/entities/payment_method.dart';

import '../../../domain/entities/transaction.dart';

import '../../../domain/entities/invoice.dart';
import '../../../domain/usecases/filters/filter_transactions.dart';

class FilterTransactionsImpl implements FilterTransactions {
  @override
  List<Transaction> byPaymentMethod({
    required List<Transaction> transactions,
    required PaymentMethod paymentMethod,
  }) =>
      transactions
          .where((transaction) => transaction.paymentMethod == paymentMethod)
          .toList();

  @override
  List<Transaction> byType({
    required List<Transaction> transactions,
    required TransactionType type,
  }) {
    bool Function(Transaction) isTheSpecifiedType =
        <TransactionType, bool Function(Transaction)>{
      TransactionType.expense: (t) => t.paiyable is Expense,
      TransactionType.income: (t) => t.paiyable is Income,
      TransactionType.invoice: (t) => t.paiyable is Invoice,
    }[type]!;

    return transactions.where(isTheSpecifiedType).toList();
  }

  @override
  List<Transaction> byValue({
    required List<Transaction> transactions,
    required double value,
  }) =>
      transactions.where((transaction) => transaction.value >= value).toList();
}
