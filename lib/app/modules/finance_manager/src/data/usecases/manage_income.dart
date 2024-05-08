import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/income.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/usecases/imanage_income.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/errors.dart';

class ManageIncome implements IManageIncome {
  @override
  Future<Result<void, Fail>> delete(Income income) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<Result<List<Income>, Fail>> getAllOf({
    required int month,
    required int year,
  }) {
    // TODO: implement getAllOf
    throw UnimplementedError();
  }

  @override
  Future<Result<void, Fail>> register(Income income) {
    // TODO: implement register
    throw UnimplementedError();
  }

  @override
  Future<Result<void, Fail>> update(
      {required Income oldIncome, required Income newIncome}) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
