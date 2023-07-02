import 'package:result_dart/result_dart.dart';

import '../../domain/entities/transaction.dart';
import '../../domain/usecases/iget_transactions.dart';
import '../../errors/errors.dart';

import '../repositories/itransaction_repository.dart';

class GetTransactionsUC implements IGetTransactions {
  final ITransactionRepository repository;

  GetTransactionsUC(this.repository);
  @override
  Future<Result<List<Transaction>, Fail>> call(int month) =>
      repository.getOf(month);
}
