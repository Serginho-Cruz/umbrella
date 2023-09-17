import 'package:result_dart/result_dart.dart';

import '../../domain/entities/income_parcel.dart';
import '../../errors/errors.dart';

abstract class IIncomeParcelRepository {
  Future<Result<int, Fail>> create(IncomeParcel parcel);
  Future<Result<void, Fail>> update(IncomeParcel newParcel);
  Future<Result<List<IncomeParcel>, Fail>> getAllOf({
    required int month,
    required int year,
  });
  Future<Result<void, Fail>> delete(IncomeParcel parcel);
}
