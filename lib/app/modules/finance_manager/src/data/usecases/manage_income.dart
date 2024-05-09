import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/account.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/income.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/errors.dart';

import '../../domain/usecases/manage_income.dart';

class ManageIncomeimpl implements ManageIncome {
  @override
  AsyncResult<int, Fail> register(Income income, Account account) {
    // TODO: implement register
    throw UnimplementedError();
  }

  @override
  AsyncResult<Unit, Fail> update({
    required Income oldIncome,
    required Income newIncome,
  }) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  AsyncResult<List<Income>, Fail> getAllOf({
    required int month,
    required int year,
    required Account account,
  }) {
    // TODO: implement getAllOf
    throw UnimplementedError();
  }

  @override
  AsyncResult<Unit, Fail> delete(Income income) {
    // TODO: implement delete
    throw UnimplementedError();
  }
}
