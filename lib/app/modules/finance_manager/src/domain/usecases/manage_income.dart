import 'package:result_dart/result_dart.dart';

import '../../errors/errors.dart';
import '../entities/account.dart';
import '../entities/income.dart';

abstract interface class ManageIncome {
  AsyncResult<int, Fail> register(Income income);
  AsyncResult<Unit, Fail> update({
    required Income oldIncome,
    required Income newIncome,
  });
  AsyncResult<Unit, Fail> updateValue(Income income, double newValue);
  AsyncResult<Unit, Fail> switchAccount(
    Income income,
    Account destinyAccount,
  );
  AsyncResult<List<Income>, Fail> getAllOf({
    required int month,
    required int year,
    required Account account,
  });
  AsyncResult<Unit, Fail> delete(Income income);
}
