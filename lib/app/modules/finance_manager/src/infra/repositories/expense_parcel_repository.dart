import 'package:result_dart/result_dart.dart';

import '../../data/repositories/iexpense_parcel_repository.dart';
import '../../domain/entities/expense_parcel.dart';
import '../../errors/errors.dart';

class ExpenseParcelRepository implements IExpenseParcelRepository {
  @override
  Future<Result<int, Fail>> create(ExpenseParcel parcel) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<Result<List<int>, Fail>> createAll(List<ExpenseParcel> parcels) {
    // TODO: implement createAll
    throw UnimplementedError();
  }

  @override
  Future<Result<void, Fail>> update(ExpenseParcel newParcel) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future<Result<void, Fail>> updateParcels(List<ExpenseParcel> expenseParcels) {
    // TODO: implement updateParcels
    throw UnimplementedError();
  }

  @override
  Future<Result<List<ExpenseParcel>, Fail>> getAllOf({
    required int month,
    required int year,
  }) {
    // TODO: implement getAllOf
    throw UnimplementedError();
  }

  @override
  Future<Result<void, Fail>> delete(ExpenseParcel expenseParcel) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<Result<void, Fail>> deleteParcels(List<ExpenseParcel> expenseParcels) {
    // TODO: implement deleteParcels
    throw UnimplementedError();
  }
}
