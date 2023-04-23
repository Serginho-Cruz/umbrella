import 'package:result_dart/result_dart.dart';

import '../../errors/errors.dart';
import '../entities/income.dart';
import '../entities/income_parcel.dart';

abstract class IMaintainIncome {
  Result<void, Fail> register(Income income);
  Result<void, Fail> update({
    required IncomeParcel newParcel,
    bool updateIncome = false,
    bool updateThisMonthToo = false,
  });
  Result<List<IncomeParcel>, Fail> getAll(int month);
  Result<void, Fail> delete({
    required IncomeParcel parcel,
    bool deleteIncome = false,
    bool deleteThisMonthToo = false,
  });
}
