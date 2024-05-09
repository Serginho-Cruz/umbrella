import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/balance_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/errors.dart';

import '../../domain/entities/account.dart';
import '../../domain/usecases/set_balance.dart';

class SetInitialBalance implements SetBalance {
  final BalanceRepository repository;

  SetInitialBalance(this.repository);

  @override
  AsyncResult<Unit, Fail> initial({
    required Account account,
    required double newBalance,
  }) {
    return repository.setInitial(newBalance, account);
  }
}
