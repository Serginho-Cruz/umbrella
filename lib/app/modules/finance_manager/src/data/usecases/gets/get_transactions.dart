import 'package:result_dart/result_dart.dart';

import '../../../domain/entities/account.dart';
import '../../../domain/entities/transaction.dart';
import '../../../domain/usecases/gets/get_transactions.dart';
import '../../../errors/errors.dart';
import '../../repositories/transaction_repository.dart';

class GetTransactionsOfImpl implements GetTransactionsOf {
  final TransactionRepository repository;

  GetTransactionsOfImpl(this.repository);

  @override
  Future<Result<List<Transaction>, Fail>> call({
    required int month,
    required int year,
    required Account account,
  }) =>
      repository.getAllOf(month: month, year: year, account: account);
}
