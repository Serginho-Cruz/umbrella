import 'package:result_dart/src/result.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/transaction.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/usecases/iget_transactions.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/errors.dart';

import '../repositories/itransaction_repository.dart';

class GetTransactionsUC implements IGetTransactions {
  final ITransactionRepository repository;

  GetTransactionsUC(this.repository);
  @override
  Future<Result<List<Transaction>, Fail>> call(int month) async {
    var result = await repository.getOf(month);
    return result;
  }
}
