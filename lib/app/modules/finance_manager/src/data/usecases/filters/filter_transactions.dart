import '../../../domain/entities/payment_method.dart';

import '../../../domain/entities/transaction.dart';

import '../../../domain/entities/expense_parcel.dart';
import '../../../domain/entities/income_parcel.dart';
import '../../../domain/entities/invoice.dart';
import '../../../domain/usecases/filters/ifilter_transactions.dart';

class FilterTransactions implements IFilterTransactions {
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
      TransactionType.expense: (t) => t.paiyable is ExpenseParcel,
      TransactionType.income: (t) => t.paiyable is IncomeParcel,
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
