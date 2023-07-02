import 'package:result_dart/result_dart.dart';

import '../../domain/entities/expense_parcel.dart';
import '../../errors/errors.dart';

abstract class IExpenseParcelRepository {
  Future<Result<void, Fail>> createParcelsOfInstallment({
    required List<ExpenseParcel> parcels,
    required int installmentId,
  });
  Future<Result<void, Fail>> update(ExpenseParcel newParcel);
  Future<Result<void, Fail>> updateParcels(List<ExpenseParcel> expenseParcels);
  Future<Result<List<ExpenseParcel>, Fail>> getAll(int month);
  Future<Result<List<ExpenseParcel>, Fail>> getByExpirationDate(int month);
  Future<Result<List<ExpenseParcel>, Fail>> getFirstWeekParcelsOf(int month);
  Future<Result<List<ExpenseParcel>, Fail>> getWhereExpiresOn(DateTime dTime);
  Future<Result<void, Fail>> delete(ExpenseParcel expenseParcel);
  Future<Result<void, Fail>> deleteParcels(List<ExpenseParcel> expenseParcels);
}
