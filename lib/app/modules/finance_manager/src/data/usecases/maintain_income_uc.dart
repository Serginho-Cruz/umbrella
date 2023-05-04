import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/income.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/income_parcel.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/usecases/imaintain_income.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/errors.dart';

import '../repositories/iincome_repository.dart';

class MaintainIncomeUC implements IMaintainIncome {
  final IIncomeRepository repository;

  MaintainIncomeUC(this.repository);
  @override
  Future<Result<void, Fail>> register(Income income) async {
    var result = await repository.create(income);
    return result;
  }

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
  Future<Result<List<IncomeParcel>, Fail>> getAll(int month) async {
    var result = await repository.getAll(month);
    return result;
  }

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
