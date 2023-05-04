import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/transaction.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/errors.dart';

abstract class ITransactionRepository {
  Future<Result<void, Fail>> register(Transaction transaction);
  Future<Result<List<Transaction>, Fail>> getOf(int month);
}
