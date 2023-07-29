import 'package:result_dart/result_dart.dart';

import '../../errors/errors.dart';
import '../entities/income.dart';
import '../entities/income_parcel.dart';

abstract class IManageIncome {
  Future<Result<void, Fail>> register(Income income);
  Future<Result<void, Fail>> updateIncome(Income newIncome);
  Future<Result<void, Fail>> updateParcel({
    required IncomeParcel oldParcel,
    required IncomeParcel newParcel,
  });

  Future<Result<List<IncomeParcel>, Fail>> getAllOf({
    required int month,
    required int year,
  });
  Future<Result<void, Fail>> deleteIncome(Income income);
  Future<Result<void, Fail>> deleteParcel(IncomeParcel parcel);
}
