import 'package:result_dart/result_dart.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/data/repositories/iincome_parcel_repository.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/domain/entities/income_parcel.dart';
import 'package:umbrella_echonomics/app/modules/finance_manager/src/errors/errors.dart';

class IncomeParcelRepository implements IIncomeParcelRepository {
  @override
  Future<Result<int, Fail>> create(IncomeParcel parcel) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<Result<void, Fail>> update(IncomeParcel newParcel) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future<Result<List<IncomeParcel>, Fail>> getAllOf({
    required int month,
    required int year,
  }) {
    // TODO: implement getAllOf
    throw UnimplementedError();
  }

  @override
  Future<Result<void, Fail>> delete(IncomeParcel parcel) {
    // TODO: implement delete
    throw UnimplementedError();
  }
}
