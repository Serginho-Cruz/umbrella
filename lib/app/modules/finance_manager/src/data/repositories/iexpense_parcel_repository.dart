import 'package:result_dart/result_dart.dart';

import '../../domain/entities/expense_parcel.dart';
import '../../errors/errors.dart';

abstract class IExpenseParcelRepository {
  Future<Result<int, Fail>> create(ExpenseParcel parcel);
  Future<Result<List<int>, Fail>> createAll(List<ExpenseParcel> parcels);
  Future<Result<void, Fail>> update(ExpenseParcel newParcel);
  Future<Result<void, Fail>> updateParcels(List<ExpenseParcel> expenseParcels);
  Future<Result<List<ExpenseParcel>, Fail>> getAllOf({
    required int month,
    required int year,
  });
  Future<Result<void, Fail>> delete(ExpenseParcel expenseParcel);
  Future<Result<void, Fail>> deleteParcels(List<ExpenseParcel> expenseParcels);
}
