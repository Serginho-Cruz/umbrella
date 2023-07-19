import 'package:result_dart/result_dart.dart';

import '../../../domain/entities/transaction.dart';
import '../../../domain/usecases/gets/iget_transactions.dart';
import '../../../errors/errors.dart';

import '../../repositories/itransaction_repository.dart';

class GetTransactionsOf implements IGetTransactionsOf {
  final ITransactionRepository repository;

  GetTransactionsOf(this.repository);

  @override
  Future<Result<List<Transaction>, Fail>> call(DateTime month) =>
      repository.getOf(month);
}
