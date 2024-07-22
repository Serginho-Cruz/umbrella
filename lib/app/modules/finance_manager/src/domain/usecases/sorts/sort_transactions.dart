import '../../entities/transaction.dart';

abstract interface class SortTransactions {
  List<Transaction> byValue({
    required List<Transaction> transactions,
    bool isCrescent,
  });

  List<Transaction> byPaymentDate({
    required List<Transaction> transactions,
    bool isCrescent,
  });
  List<Transaction> byID(List<Transaction> transactions);
  List<Transaction> revertSort(List<Transaction> transactions);
}
