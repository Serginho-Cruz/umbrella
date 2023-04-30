import 'package:result_dart/result_dart.dart';

import '../../errors/errors.dart';
import '../entities/income.dart';
import '../entities/income_parcel.dart';

abstract class IMaintainIncome {
  Future<Result<void, Fail>> register(Income income);
  Future<Result<void, Fail>> update({
    required IncomeParcel newParcel,
    bool updateIncome = false,
    bool updateThisMonthToo = false,
  });
  Future<Result<List<IncomeParcel>, Fail>> getAll(int month);
  Future<Result<void, Fail>> delete({
    required IncomeParcel parcel,
    bool deleteIncome = false,
    bool deleteThisMonthToo = false,
  });
}
