import 'package:result_dart/result_dart.dart';
import '../../domain/entities/income.dart';
import '../../domain/entities/income_parcel.dart';
import '../../domain/usecases/imaintain_income.dart';
import '../../errors/errors.dart';

import '../repositories/iincome_repository.dart';

class MaintainIncomeUC implements IMaintainIncome {
  final IIncomeRepository repository;

  MaintainIncomeUC(this.repository);
  @override
  Future<Result<void, Fail>> register(Income income) =>
      repository.create(income);

  @override
  Future<Result<void, Fail>> update({
    required IncomeParcel newParcel,
    bool updateIncome = false,
  }) async {
    var parcelResult = await repository.updateParcel(newParcel);
    if (parcelResult.isError()) {
      return parcelResult;
    }

    if (updateIncome) {
      var result = await repository.updateIncome(newParcel.income);
      return result;
    }

    return parcelResult;
  }

  @override
  Future<Result<List<IncomeParcel>, Fail>> getAll(int month) =>
      repository.getAll(month);

  @override
  Future<Result<List<IncomeParcel>, Fail>> getByPaymentDate(int month) =>
      repository.getByPaymentDate(month);

  @override
  Future<Result<void, Fail>> delete({
    required IncomeParcel parcel,
    bool deleteIncome = false,
  }) async {
    var parcelResult = await repository.deleteParcel(parcel);
    if (parcelResult.isError()) {
      return parcelResult;
    }

    if (deleteIncome) {
      var result = await repository.deleteIncome(parcel.income);
      return result;
    }

    return parcelResult;
  }
}
