import 'package:result_dart/result_dart.dart';

import '../../domain/entities/paiyable.dart';
import '../../domain/entities/transaction.dart';
import '../../errors/errors.dart';

abstract class ITransactionRepository {
  Future<Result<int, Fail>> register(Transaction transaction);
  Future<Result<List<Transaction>, Fail>> getAllOf({
    required int month,
    required int year,
  });
  Future<Result<void, Fail>> deleteAllOf(Paiyable paiyable);
}
