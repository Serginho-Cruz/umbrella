import '../../entities/transaction.dart';

abstract interface class OrderTransactions {
  List<Transaction> byValue({
    required List<Transaction> transactions,
    bool isCrescent,
  });

  List<Transaction> byPaymentDate({
    required List<Transaction> transactions,
    bool isCrescent,
  });
  List<Transaction> byID(List<Transaction> transactions);
  List<Transaction> revertOrder(List<Transaction> transactions);
}
