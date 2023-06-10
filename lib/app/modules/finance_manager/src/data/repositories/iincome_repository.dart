import 'package:result_dart/result_dart.dart';
import '../../domain/entities/income_parcel.dart';
import '../../errors/errors.dart';

import '../../domain/entities/income.dart';

abstract class IIncomeRepository {
  Future<Result<void, Fail>> create(Income income);
  Future<Result<void, Fail>> updateParcel(IncomeParcel newParcel);
  Future<Result<void, Fail>> updateIncome(Income newIncome);
  Future<Result<List<IncomeParcel>, Fail>> getAll(int month);
  Future<Result<List<IncomeParcel>, Fail>> getByPaymentDate(int month);
  Future<Result<void, Fail>> deleteParcel(IncomeParcel parcel);
  Future<Result<void, Fail>> deleteIncome(Income income);
}
