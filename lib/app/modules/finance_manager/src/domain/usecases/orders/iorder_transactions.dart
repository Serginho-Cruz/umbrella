import '../../entities/transaction.dart';

abstract class OrderTransactions {
  List<Transaction> byValue({
    required List<Transaction> transactions,
    required bool isCrescent,
  });

  List<Transaction> byPaymentDate({
    required List<Transaction> transactions,
    required bool isCrescent,
  });
  List<Transaction> byID({
    required List<Transaction> transactions,
    required bool isCrescent,
  });
}
