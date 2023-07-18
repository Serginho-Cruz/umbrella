import 'package:result_dart/result_dart.dart';

import '../../domain/entities/transaction.dart';
import '../../domain/usecases/gets/iget_transactions.dart';
import '../../errors/errors.dart';

import '../repositories/itransaction_repository.dart';

class GetTransactions implements IGetTransactionsOf {
  final ITransactionRepository repository;

  GetTransactions(this.repository);

  @override
  Future<Result<List<Transaction>, Fail>> call(DateTime month) {
    // TODO: implement call
    throw UnimplementedError();
  }
}
