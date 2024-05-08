import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/balance_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/errors.dart';

import '../../domain/entities/account.dart';
import '../../domain/usecases/iset_balance.dart';

class SetInitialBalance implements ISetBalance {
  final BalanceRepository repository;

  SetInitialBalance(this.repository);

  @override
  AsyncResult<void, Fail> initial({
    required double newBalance,
    required Account account,
  }) {
    return repository.setInitial(newBalance, account);
  }
}
