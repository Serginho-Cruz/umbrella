import '../../domain/entities/account.dart';
import '../../domain/entities/paiyable.dart';
import '../../domain/entities/transaction.dart';

abstract interface class TransactionDatasource {
  Future<int> register(Transaction transaction, Account account);
  Future<List<Transaction>> getAllOf({
    required Account account,
    required int month,
    required int year,
  });
  Future<void> deleteAllOf(Paiyable paiyable);
}
