import '../../entities/transaction.dart';

abstract class IOrderTransactions {
  List<Transaction> byValue({
    required List<Transaction> transactions,
    required bool isCrescent,
  });

  List<Transaction> byPaymentDate({
    required List<Transaction> transactions,
    required bool isCrescent,
  });
  List<Transaction> byID(List<Transaction> transactions);
  List<Transaction> revertOrder(List<Transaction> transactions);
}
