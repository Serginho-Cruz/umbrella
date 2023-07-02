import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/iincome_parcel_repository.dart';
import '../../domain/entities/income.dart';
import '../../domain/entities/income_parcel.dart';
import '../../domain/usecases/imaintain_income.dart';
import '../../errors/errors.dart';

import '../repositories/iincome_repository.dart';

class MaintainIncomeUC implements IMaintainIncome {
  final IIncomeRepository incomeRepository;
  final IIncomeParcelRepository incomeParcelRepository;

  MaintainIncomeUC({
    required this.incomeRepository,
    required this.incomeParcelRepository,
  });
  @override
  Future<Result<void, Fail>> register(Income income) =>
      incomeRepository.create(income);

  @override
  Future<Result<void, Fail>> update({
    required IncomeParcel newParcel,
    bool updateIncome = false,
  }) async {
    var parcelResult = await incomeParcelRepository.update(newParcel);
    if (parcelResult.isError()) {
      return parcelResult;
    }

    if (updateIncome) {
      var result = await incomeRepository.update(newParcel.income);
      return result;
    }

    return parcelResult;
  }

  @override
  Future<Result<List<IncomeParcel>, Fail>> getAll(int month) =>
      incomeParcelRepository.getAll(month);

  @override
  Future<Result<List<IncomeParcel>, Fail>> getByPaymentDate(int month) =>
      incomeParcelRepository.getByPaymentDate(month);

  @override
  Future<Result<void, Fail>> delete({
    required IncomeParcel parcel,
    bool deleteIncome = false,
  }) async {
    var parcelResult = await incomeParcelRepository.delete(parcel);
    if (parcelResult.isError()) {
      return parcelResult;
    }

    if (deleteIncome) {
      var result = await incomeRepository.delete(parcel.income);
      return result;
    }

    return parcelResult;
  }
}
