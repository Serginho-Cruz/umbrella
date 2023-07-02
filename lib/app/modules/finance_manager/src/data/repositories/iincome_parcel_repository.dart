import 'package:result_dart/result_dart.dart';

import '../../domain/entities/income_parcel.dart';
import '../../errors/errors.dart';

abstract class IIncomeParcelRepository {
  Future<Result<void, Fail>> create(IncomeParcel parcel);
  Future<Result<void, Fail>> update(IncomeParcel newParcel);
  Future<Result<List<IncomeParcel>, Fail>> getAll(int month);
  Future<Result<List<IncomeParcel>, Fail>> getByPaymentDate(int month);
  Future<Result<void, Fail>> delete(IncomeParcel parcel);
}
