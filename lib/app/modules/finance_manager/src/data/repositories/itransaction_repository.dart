import 'package:result_dart/result_dart.dart';

import '../../domain/entities/transaction.dart';
import '../../errors/errors.dart';

abstract class ITransactionRepository {
  Future<Result<void, Fail>> register(Transaction transaction);
  Future<Result<List<Transaction>, Fail>> getOf(int month);
}
