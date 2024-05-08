import 'package:result_dart/result_dart.dart';

import '../../domain/entities/account.dart';
import '../../domain/entities/paiyable.dart';
import '../../domain/entities/transaction.dart';
import '../../errors/errors.dart';

abstract interface class TransactionRepository {
  AsyncResult<int, Fail> register(Transaction transaction, Account account);
  AsyncResult<List<Transaction>, Fail> getAllOf({
    required int month,
    required int year,
    required Account account,
  });
  AsyncResult<Unit, Fail> deleteAllOf(Paiyable paiyable);
}
