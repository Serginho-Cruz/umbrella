import 'package:result_dart/result_dart.dart';

import '../../errors/errors.dart';
import '../entities/income_parcel.dart';

abstract class IReceiveIncome {
  Result<void, Fail> call({
    required IncomeParcel income,
    required double value,
  });
  Result<void, Fail> advanceIncome({
    required IncomeParcel income,
    required double valueToAdvance,
  });
}
