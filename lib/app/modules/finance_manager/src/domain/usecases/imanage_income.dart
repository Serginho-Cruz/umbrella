import 'package:result_dart/result_dart.dart';

import '../../errors/errors.dart';
import '../entities/income.dart';
import '../entities/income_parcel.dart';

abstract class IManageIncome {
  Future<Result<void, Fail>> register(Income income);
  Future<Result<void, Fail>> update({
    required IncomeParcel newParcel,
    bool updateIncome = false,
  });
  Future<Result<List<IncomeParcel>, Fail>> getAllOf(DateTime month);
  Future<Result<void, Fail>> delete({
    required IncomeParcel parcel,
    bool deleteIncome = false,
  });
}
