import '../../../domain/entities/transaction.dart';
import '../../../domain/usecases/orders/order_transactions.dart';

class OrderTransactionsImpl implements OrderTransactions {
  @override
  List<Transaction> byID(List<Transaction> transactions) =>
      List.from(transactions)..sort((a, b) => a.id.compareTo(b.id));

  @override
  List<Transaction> byValue({
    required List<Transaction> transactions,
    bool isCrescent = true,
  }) =>
      _sortList(
        sortFunction: (a, b) => a.value.compareTo(b.value),
        transactions: transactions,
        isCrescent: isCrescent,
      );
  @override
  List<Transaction> byPaymentDate({
    required List<Transaction> transactions,
    bool isCrescent = true,
  }) =>
      _sortList(
        sortFunction: (a, b) => a.paymentDate.compareTo(b.paymentDate),
        transactions: transactions,
        isCrescent: isCrescent,
      );

  @override
  List<Transaction> revertOrder(List<Transaction> transactions) =>
      transactions.reversed.toList();

  List<Transaction> _sortList({
    required int Function(Transaction, Transaction) sortFunction,
    required List<Transaction> transactions,
    required bool isCrescent,
  }) {
    //Multiplier Number in compare will order the list in crescent or decrescent
    //without using .reverse in the final of processing, saving cellphone resources
    int multiplierNumber = isCrescent ? 1 : -1;
    return List.from(transactions)
      ..sort((a, b) => sortFunction(a, b) * multiplierNumber);
  }
}
