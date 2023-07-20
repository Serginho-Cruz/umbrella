import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/iincome_parcel_repository.dart';
import '../../domain/entities/income.dart';
import '../../domain/entities/income_parcel.dart';
import '../../domain/usecases/imanage_income.dart';
import '../../errors/errors.dart';

import '../repositories/iincome_repository.dart';

class ManageIncome implements IManageIncome {
  final IIncomeRepository incomeRepository;
  final IIncomeParcelRepository incomeParcelRepository;

  ManageIncome({
    required this.incomeRepository,
    required this.incomeParcelRepository,
  });

  @override
  Future<Result<void, Fail>> delete({
    required IncomeParcel parcel,
    bool deleteIncome = false,
  }) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<Result<List<IncomeParcel>, Fail>> getAllOf({
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
  Future<Result<void, Fail>> update({
    required IncomeParcel newParcel,
    bool updateIncome = false,
  }) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
